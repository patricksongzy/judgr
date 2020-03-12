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

    for test_datum in test_data
      File.open("#{Rails.root}/datasets/#{uuid}/#{test_datum.original_filename}", "w") do |f|
        f.write(test_datum.read)
      end
    end
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
