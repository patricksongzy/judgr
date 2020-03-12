require "#{Rails.root}/lib/console_runner/console_runner.rb"

class Problem < ApplicationRecord
  has_many :submissions
  belongs_to :contest

  attr_accessor :problem_data

  before_create :set_uuid
  before_destroy :delete_dataset

  def create_dataset(test_data)
    cr = ConsoleRunner.new("rm -r #{Rails.root}/datasets/#{uuid}")
    cr.finish
    cr = ConsoleRunner.new("mkdir -p #{Rails.root}/datasets/#{uuid}")
    cr.finish

    @test_data = Hash.new
    for test_datum in test_data
      file_extension = File.extname(test_datum)
      unless [".in", ".out"].include? file_extension
        next
      end

      file_path = "#{Rails.root}/datasets/#{uuid}/#{test_datum.original_filename}"

      File.open(file_path, "w") do |f|
        f.write(test_datum.read)
      end

      if file_extension == ".out"
        @test_data[file_path.chomp(".in") << ".out"] = file_path
      end
    end
  end

  def get_data()
    if @test_data.nil?
      @test_data = Hash.new
      for f in Dir.glob("#{Rails.root}/datasets/#{uuid}/*.in")
        @test_data[f] = f.chomp('.in') << '.out'
      end
    end

    @test_data
  end

  private

  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  def delete_dataset
    cr = ConsoleRunner.new("rm -r #{Rails.root}/datasets/#{uuid}")
    cr.finish
  end
end
