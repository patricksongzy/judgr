require "#{Rails.root}/lib/console_runner/console_runner.rb"

class Submission < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :problem
  belongs_to :language
  belongs_to :user

  attr_accessor :code_file

  # memory limit for compilation
  COMPILE_MEMORY_LIMIT = 4096000
  # memory limit in kilobytes for ulimit
  MEMORY_LIMIT = 512000
  # code file size limit in bytes
  CODE_SIZE_LIMIT = 128000

  JAVA_ARGS = "-Xmx192m -XX:+UseCompressedClassPointers -XX:CompressedClassSpaceSize=32m -XX:MaxMetaspaceSize=32m"

  ##
  # Gets the name of the submission.
  #
  def get_name
    "Submission #{id}: #{language.name}"
  end

  ##
  # Gets ancestors for the breadcrumb.
  #
  def get_ancestors(is_editing)
    ancestors = []
    ancestors << [get_name, submission_path(self)]
    ancestors += problem.get_ancestors(is_editing)
  end

  ##
  # Sets up a submission to be run.
  #
  def create(current_user)
    if code_file.nil?
      errors.add(:submission, I18n.t('submissions.form.errors.required'))
      return
    else
      if File.size(code_file) > CODE_SIZE_LIMIT
        errors.add(:submission, I18n.t('submissions.form.errors.too_large'))
        return
      end

      unless FileMagic.new(FileMagic::MAGIC_MIME).file(code_file.path).include? "text/"
        errors.add(:submission, I18n.t('submissions.form.errors.binary_file'))
        return
      end

      allowed_extensions = Language.all.pluck(:extension)
      code_file_extension = File.extname(code_file.original_filename)

      unless allowed_extensions.include? code_file_extension
        errors.add(:submission, I18n.t('submissions.form.errors.unknown_language', extension: code_file_extension))
        return
      end
    end

    problem.prepare_dataset
    language = Language.where(:extension => File.extname(code_file.original_filename)).first

    self.language_id = language.id
    self.code = code_file.read
    self.user_id = current_user.id
  end

  ##
  # Runs and scores the submission in a sandboxed environment.
  #
  def process
    self.score = 0
    self.success = false

    # the directory of the submission
    submission_directory = "#{Rails.root}/submissions/#{id}/"
    # the source file name
    source_name = "Main#{language.extension}"
    # the path to the source file
    source_path = "#{submission_directory}#{source_name}"
    # the path to the sandbox shell file
    bwrap_path = "#{Rails.root}/lib/bwrapper/run_sandbox.sh"

    # create the submission directory and a folder for the compiled submission
    cr = ConsoleRunner.new("mkdir -p #{submission_directory} && mkdir -p #{submission_directory}/compiled")
    cr.finish

    # writes the code to the file
    File.open(source_path, "w") do |file|
      file.write(code)
    end

    # the location where the submission is stored in the sandbox
    sb_submission_directory = "/tmp/submission/"
    # the location where the compiled submission is stored in the sandbox
    sb_compiled_directory = "/tmp/compiled/"
    # the location where the source file is stored in the sandbox
    sb_source_path = "#{sb_submission_directory}#{source_name}"
    memory_offset = 0
    # initialize the commands for the languages
    case language.name
    when "Java"
      compile_command = "javac -d #{sb_compiled_directory} #{sb_source_path}"
      run_command = "java #{JAVA_ARGS} -cp #{sb_compiled_directory} Main"
      memory_offset = 512000
    when "C"
      compile_command = "gcc -o #{sb_compiled_directory}Main.out #{sb_source_path}"
      run_command = "./#{sb_compiled_directory}Main.out"
    when "Python"
      run_command = "python3 #{sb_source_path}"
    end

    # ensure the language needs to be compiled
    if not compile_command.nil?
      begin
        # set a timeout to avoid compiler bombs
        Timeout.timeout(10) do
          Rails.logger.info "Compiling: #{wrap_sandbox("#{bwrap_path} '#{compile_command}' '#{submission_directory}'", COMPILE_MEMORY_LIMIT + memory_offset)}"

          # run the compilation in a sandbox for security reasons
          cr = ConsoleRunner.new(wrap_sandbox("#{bwrap_path} '#{compile_command}' '#{submission_directory}'", COMPILE_MEMORY_LIMIT + memory_offset))
          message, error_text, status = cr.finish

          Rails.logger.info "Message: #{message}."

          # ensure compilation is successful to proceed
          if not status.success?
            Rails.logger.info "Error during compilation: #{error_text}"

            self.message = "Compilation error."
            return
          end
        end
      rescue Timeout::Error
        Rails.logger.debug "Compilation time limit exceeded: killing sandbox."
        cr.kill

        self.message = "Compilation time limit exceeded."
        return
      end
    end

    time_limit = problem.time_limit
    test_data = problem.get_data

    begin
      # add an extra timeout for safety
      begin
        for input_file in test_data.keys.sort
          Timeout.timeout(time_limit + 5) do
            Rails.logger.info "Running: #{wrap_sandbox("#{bwrap_path} 'timeout #{time_limit} #{run_command}' '#{submission_directory}'", MEMORY_LIMIT + memory_offset)}"

            # add a memory limit, a CPU limit, and a time limit
            cr = ConsoleRunner.new(wrap_sandbox("#{bwrap_path} 'timeout #{time_limit} #{run_command}' '#{submission_directory}'", MEMORY_LIMIT + memory_offset))

            File.open(input_file, "r") do |f|
              f.each_line do |line|
                cr.write_input(line)
              end
            end

            output_text, error_text, status = cr.finish
            Rails.logger.info "Submission outputted: #{output_text}"

            if status.exitstatus == 124
              Rails.logger.debug "Submission time limit exceeded: killing sandbox."

              self.message = "Time limit exceeded."
              return
            end

            if not status.success?
              Rails.logger.info "Error running submission: #{error_text}"

              self.message = "Runtime error."
              return
            else
              pass = true

              File.open(test_data[input_file], "r") do |f|
                f.each_line.zip(output_text.each_line) do |target, output|
                  unless target == output
                    pass = false
                    break
                  end
                end
              end

              if pass
                self.score += 1
              end
            end
          rescue Timeout::Error
            self.message = "Time limit exceeded."
            return
          end
        end
      ensure
        # ensure the sandbox is always killed for security
        cr.kill
        
        # remove the submission folder to avoid clutter
        cr = ConsoleRunner.new("rm -r #{submission_directory}")
        cr.finish
      end
    end

    self.message = "Successfully scored submission."
    self.success = true
  end

  ##
  # Gets the submission score formatted out of the maximum possible score.
  #
  def get_formatted_score
    return "#{score} / #{problem.get_max_score}"
  end

  ##
  # Gets the submission message.
  #
  def get_message
    return "Submission is being processed." if message.nil?
    return message
  end

  private

  def wrap_sandbox(command, memory_limit)
    return "(ulimit -Sv #{memory_limit} -Hv #{memory_limit}; cpulimit -l 50 -- bash #{command})"
  end
end

