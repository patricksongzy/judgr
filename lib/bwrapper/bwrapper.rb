require 'set'

require "#{Rails.root}/lib/console_runner/console_runner.rb"

class BWrapper
  def self.create_generic
    file_name = "lib/bwrapper/run_sandbox.sh"
    unless File.file?(file_name)
      wrapper = BWrapper.new(file_name, ["cairo", "gtk", "x11", "libgl", "site-packages"])
      wrapper.wrap(["java", "javac", "gcc", "python3", "as", "ld", "timeout"], library_directories: ["gcc", "python*", "x86_64-linux-gnu"], custom_paths: ["/usr/lib/x86_64-linux-gnu", "/usr/lib64/ld-linux*"])
    end
    
    cr = ConsoleRunner.new("chmod +x #{file_name}")
    cr.finish
  end

  def initialize(output_location, blacklisted_names)
    puts "Generating shell script..."
    @f = File.open(output_location, "w")
    @blacklisted_names = blacklisted_names
    @blacklist_filters = get_blacklist_filters(blacklisted_names)
    @visited_libraries = Set.new
    @executable_paths = Set.new
  end

  def wrap(command_names, library_directories: [], custom_paths: [])
    @f.write("execution=$1\n")
    @f.write("path=$2\n")
    @f.write("clean_execution=${execution//[^a-zA-Z0-9\s.\/-]/}\n")
    @f.write("clean_path=${path//[^a-zA-Z0-9\s.\/-]/}\n")

    @f.write("if [ -z \"$clean_path\" ] || [ -z \"$clean_execution\" ] ; then\n")
    @f.write("  echo \"Missing required arguments.\"\n")
    @f.write("  exit 1\n")
    @f.write("fi\n")

    @f.write("(exec bwrap ")

    puts "Adding executables..."
    for command in command_names
      add_executable_link("/usr/bin/#{command}")
    end

    puts "Adding libraries..."
    for library in library_directories
      add_library_wildcard(library, true)
    end

    for path in custom_paths
      add_custom_path(path)
    end

    write_argument("ro-bind", "/usr/include", "/usr/include")

    puts "Adding gcc libraries..."

    # required by gcc
    add_library_wildcard("*crt*.o", false)
    add_library_wildcard("*libgcc*.so*", false)
    add_library_wildcard("libc.a", false)
    add_library_wildcard("libc_nonshared.a", false)
    add_library_wildcard("ld-linux*", false)
    add_library_wildcard("libc*.so*", false)
    add_required_libraries

    puts "Adding links and other folders..."

    write_argument("symlink", "/usr/lib", "/lib")
    write_argument("symlink", "/usr/lib64", "/lib64")
    write_argument("symlink", "/usr/bin", "/bin")
    
    write_argument("proc", "/proc")

    write_argument("tmpfs", "/tmp")
    write_argument("tmpfs", "/var")
    write_argument("bind", "$clean_path/compiled", "/tmp/compiled")
    write_argument("ro-bind", "$clean_path", "/tmp/submission")
    write_argument("chdir", "/")
    write_argument("unshare-all")
    write_argument("new-session")
    write_argument("die-with-parent")
    write_argument("dir", "/run/user/$(id -u)")
    write_argument("setenv", "XDG_RUNTIME_DIR", "'/run/user/`id -u`'")
    @f.write("$clean_execution)")
    @f.close
  end

  private

  ##
  # Adds an argument and its values to the command.
  # 
  def write_argument(argument_name, *argument_values)
    if argument_values.any? { |value| value.empty? }
      puts "Skipping argument --#{argument_name}: empty argument value provided."
    end

    @f.write("--#{argument_name} ")
    for argument_value in argument_values
      @f.write("#{argument_value} ")
    end
  end

  def get_blacklist_filters(blacklisted_names)
    blacklist_filters = ""
    for blacklisted in blacklisted_names
      blacklist_filters += "| grep -iv #{blacklisted} "
    end
    
    blacklist_filters
  end

  ##
  # Finds executables in a specefied library directory, wiht a blacklist.
  #
  def find_executables(library_path)
    library_path = library_path.chomp('/')

    # globstar is needed for double asterix wildcard
    cr = ConsoleRunner.new("shopt -s globstar && find #{library_path}/**/ executable -type f #{@blacklist_filters}")
    executable_paths, _, _ = cr.finish
    executable_paths.split("\n")
  end

  ##
  # Retrieves the location to which a link is pointing to.
  #
  def get_linked_location(link_path, arguments: "")
    cr = ConsoleRunner.new("readlink -f #{link_path} #{arguments}")
    linked_location, _, _ = cr.finish
    linked_location.delete("\n")
  end

  ##
  # Adds symbolic links from linked locations to the link path, and read-only binds executables.
  #
  def add_executable_link(executable_path)
    linked_location = get_linked_location(executable_path)
    @executable_paths += [linked_location]

    if linked_location == executable_path
      write_argument("ro-bind", executable_path, executable_path)
    else
      write_argument("symlink", linked_location, executable_path)

      link_directory = linked_location.match(/\/usr\/.*?\/[^\/]*/).to_s
      add_library_directory(link_directory)
    end
  end

  def add_custom_path(path_wildcard)
    cr = ConsoleRunner.new("find #{path_wildcard} -maxdepth 0 #{@blacklist_filters}")
    paths, _, _ = cr.finish
    paths = paths.split("\n")

    for path in paths
      write_argument("ro-bind", path, path)
    end
  end

  def add_library_wildcard(library_wildcard, is_directory)
    cr = ConsoleRunner.new("find /usr/lib/#{library_wildcard} -maxdepth 0 #{is_directory ? '-type d' : ''} #{@blacklist_filters}")
    paths, _, _ = cr.finish
    paths = paths.split("\n")

    if is_directory
      for directory in paths
        add_library_directory(directory)
      end
    else
      for path in paths
        write_argument("ro-bind", path, path)
      end
    end
  end

  def blacklist_subdirectories(directory_path)
    for blacklisted in @blacklisted_names
      cr = ConsoleRunner.new("find #{directory_path}/*#{blacklisted}* -maxdepth 0 -type d")
      results, _, _ = cr.finish
      if not results.empty?
        for result in results.split("\n")
          write_argument("tmpfs", "#{result}")
        end
      end
    end
  end

  def add_library_directory(directory_path)
    if not @visited_libraries.include? directory_path
      @visited_libraries += [directory_path]
      write_argument("ro-bind", directory_path, directory_path)

      add_links(directory_path)
      # blacklist subdirectories read-only binding a directory will provide read-only access to them
      blacklist_subdirectories(directory_path)

      # blacklisted executables and subdirectories are removed through grep
      @executable_paths += find_executables(directory_path).map do |executable|
        get_linked_location(executable)
      end
    end
  end

  ##
  # Finds any links in a given directory.
  #
  def find_links(directory_path)
    directory_path = directory_path.chomp('/')
    cr = ConsoleRunner.new("find #{directory_path}/ -type l #{@blacklist_filters}")
    links, _, _ = cr.finish
    links.split("\n")
  end

  ##
  # Ensures links are properly configured and that their destinations are bound.
  #
  def add_links(directory_path)
    links = find_links(directory_path)
    for link in links
      linked_location = get_linked_location(link, arguments: "| grep -v #{directory_path} #{@blacklist_filters}")
      if linked_location.empty?
        next
      end

      write_argument("ro-bind", linked_location, linked_location)
    end
  end

  ##
  # Gets a list of required libraries.
  #
  def get_required_libraries
    required_libraries = Set.new

    for executable in @executable_paths
      cr = ConsoleRunner.new("ldd #{executable}")
      libraries, _, status = cr.finish

      if status.success?
        required_libraries += libraries.scan(/=>\s((?:\/.*?)+)\s/).flatten
      end
    end

    required_libraries
  end

  ##
  # Adds the required libraries to the bubblewrap command.
  # 
  def add_required_libraries
    required_libraries = get_required_libraries

    for required in required_libraries
      if @blacklisted_names.any? { |blacklisted| required.downcase.include?(blacklisted) == 0 }
        puts "Skipping blacklisted library #{required}."
        next
      end
 
      write_argument("ro-bind", required, required.sub(/^\/lib/, "/usr/lib"))
    end
  end
end

