require "#{Rails.root}/lib/console_runner/console_runner.rb"

class Submission < ApplicationRecord
  belongs_to :problem
  belongs_to :language
  belongs_to :user

  attr_accessor :code_file

  def process
    submission_directory = "#{Rails.root}/submissions/#{id}/"
    source_name = "Main#{language.extension}"
    source_path = "#{submission_directory}#{source_name}"
    bwrap_path = "#{Rails.root}/lib/bwrapper/run_sandbox.sh"

    cr = ConsoleRunner.new("mkdir -p #{submission_directory} && mkdir -p #{submission_directory}/compiled")
    cr.finish

    File.open(source_path, "w") do |file|
      file.write(code)
    end

    sb_submission_directory = "/tmp/submission/"
    sb_compiled_directory = "/tmp/compiled/"
    sb_source_path = "#{sb_submission_directory}#{source_name}"
    case language.name
    when "Java"
      compile_command = "javac -d #{sb_compiled_directory} #{sb_source_path}"
      run_command = "java -cp #{sb_compiled_directory} Main"
    when "C"
      compile_command = "gcc -o #{sb_compiled_directory}Main.out #{sb_source_path}"
      run_command = "./#{sb_compiled_directory}Main.out"
    when "Python"
      run_command = "python #{sb_source_path}"
    end

    if not compile_command.nil?
      begin
        Timeout.timeout(2) do
          cr = ConsoleRunner.new("#{bwrap_path} '#{compile_command}' '#{submission_directory}'")
          _, _, status = cr.finish
          
          if not status.success?
            return "compilation error"
          end
        end
      rescue Timeout::Error
        cr.kill
        puts "COMPILE TIME LIMIT"
        return "compilation time limit"
      end
    end

    begin
      Timeout.timeout(2) do
        begin
          cr = ConsoleRunner.new("#{bwrap_path} '#{run_command}' '#{submission_directory}'")
          cr.write_input("8")

          output_text, _, status = cr.finish
          
          cr = ConsoleRunner.new("rm -r #{submission_directory}")
          cr.finish

          if not status.success?
            "execution error"
          else
            output_text
          end
        ensure
          cr.kill
        end
      end
    rescue Timeout::Error
      cr.kill
      puts "TIME LIMIT"
      return "time limit"
    end
  end
end

