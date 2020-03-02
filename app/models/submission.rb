require 'open3'

class Submission < ApplicationRecord
  belongs_to :problem
  belongs_to :language
  belongs_to :user

  def process
    directory_path = "submissions/#{id}/"
    file_path = "#{directory_path}Main#{language.extension}"

    cr = ConsoleRunner.new("mkdir -p #{directory_path} && mkdir -p #{directory_path}/compiled")
    cr.run

    File.open(file_path, "w") do |file|
      file.write(code)
    end

    case language.name
    when "Java"
      compile_command = "javac #{file_path}"
      run_command = "java -cp #{directory_path} Main"
    when "C"
      compiled_path = "#{directory_path}Main.out"
      compile_command = "gcc -o #{compiled_path} #{file_path}"
      run_command = "./#{compiled_path}"
    when "Python"
      run_command = "python #{file_path}"
    end

    if not compile_command.nil?
      cr = ConsoleRunner.new(compile_command)
      _, _, status = cr.run
      
      if not status.success?
        "compilation error"
      end
    end

    cr = ConsoleRunner.new(run_command)
    output_text, _, status = cr.run
    
    if not status.success?
      "execution error"
    else
      output_text
    end
  end
end

