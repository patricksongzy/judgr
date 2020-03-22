require "#{Rails.root}/lib/console_runner/console_runner.rb"

class Problem < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_many :submissions
  belongs_to :contest

  attr_accessor :problem_data
  validates :problem_data, presence: true

  before_create :set_uuid
  before_destroy :delete_dataset

  ##
  # Gets the problem description or a template to edit.
  #
  def get_description
    return description if description
    I18n.t('problem_description')
  end

  ##
  # Gets ancestors for the breadcrumb.
  #
  def get_ancestors(is_editing)
    ancestors = []
    
    # determine which path to return
    if is_editing
      path = edit_admin_contest_problem_path(self)
    else
      path = problem_path(self)
    end

    ancestors << [name, path]
    ancestors += contest.get_ancestors(is_editing)
  end

  ##
  # Creates a dataset folder for the problem.
  #
  def create_dataset
    cr = ConsoleRunner.new("rm -r #{Rails.root}/datasets/#{uuid}")
    cr.finish
    cr = ConsoleRunner.new("mkdir -p #{Rails.root}/datasets/#{uuid}")
    cr.finish

    @test_data = Hash.new
    for test_datum in problem_data
      file_extension = File.extname(test_datum)
      # filter out unwanted files
      unless [".in", ".out"].include? file_extension
        next
      end

      file_path = "#{Rails.root}/datasets/#{uuid}/#{test_datum.original_filename}"

      File.open(file_path, "w") do |f|
        f.write(test_datum.read)
      end

      # link the output file with its respective input file
      if file_extension == ".out"
        @test_data[file_path.chomp(".in") << ".out"] = file_path
      end
    end
  end

  ##
  # Gets the problem data.
  #
  def get_data()
    if @test_data.nil?
      @test_data = Hash.new
      for f in Dir.glob("#{Rails.root}/datasets/#{uuid}/*.in")
        @test_data[f] = f.chomp('.in') << '.out'
      end
    end

    @test_data
  end

  ##
  # Gets the top score of the user for the problem.
  #
  def get_score(user)
    max_score = get_max_score

    if user.nil?
      return 0, max_score, "not signed in."
    end

    submissions = Submission.where(:user => user, :problem => self)
    if submissions.empty?
      return 0, max_score, "no submissions have been made yet."
    else
      score = submissions.maximum(:score)
      return score, max_score, "#{score} / #{get_max_score}"
    end
  end

  ##
  # Gets the maximum points which can be awarded for the problem.
  #
  def get_max_score
    get_data.length
  end

  private

  ##
  # Initializes the problem UUID to avoid collisions between deleted problems and new ones.
  #
  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  ##
  # Deletes the dataset folder for the problem.
  #
  def delete_dataset
    cr = ConsoleRunner.new("rm -r #{Rails.root}/datasets/#{uuid}")
    cr.finish
  end
end
