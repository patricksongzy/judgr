require "#{Rails.root}/lib/console_runner/console_runner.rb"

class Submission < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :problem
  belongs_to :language
  belongs_to :user

  attr_accessor :code_file
  validates :code_file, presence: true

  def get_name
    "Submission #{id}: #{language.name}"
  end

  def get_ancestors(is_editing)
    ancestors = []
    ancestors << [get_name, submission_path(self)]
    ancestors += problem.get_ancestors(is_editing)
  end

  def create(current_user)
    if code_file.nil?
      self.errors.add(:code_file)
      return
    end

    language = Language.where(:extension => File.extname(code_file.original_filename)).first

    if language == nil
      self.errors.add(:language)
      return
    end

    self.language_id = language.id
    self.code = code_file.read
    self.user_id = current_user.id
  end

  def process
    self.score = 0
    self.success = false

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
            self.message = "Compilation error."
            return
          end
        end
      rescue Timeout::Error
        cr.kill
        self.message = "Compilation time limit exceeded."
        return
      end
    end

    time_limit = problem.time_limit
    test_data = problem.get_data

    begin
      # add timeout for safety
      begin
        for input_file in test_data.keys.sort
          Timeout.timeout(time_limit + 5) do
            cr = ConsoleRunner.new("#{bwrap_path} 'timeout #{time_limit} #{run_command}' '#{submission_directory}'")

            File.open(input_file, "r") do |f|
              f.each_line do |line|
                cr.write_input(line)
              end
            end

            output_text, _, status = cr.finish

            if status.exitstatus == 124
              self.message = 'Time limit exceeded.'
              return
            end

            if not status.success?
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
            cr.kill
            self.message = "Time limit exceeded."
            return
          end
        end
      ensure
        cr.kill
        
        cr = ConsoleRunner.new("rm -r #{submission_directory}")
        cr.finish
      end
    end

    self.message = "Successfully scored submission."
    self.success = true
  end

  def get_score
    return "#{score} / #{problem.get_max_score}"
  end
end

