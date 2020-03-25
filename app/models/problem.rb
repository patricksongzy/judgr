require "#{Rails.root}/lib/console_runner/console_runner.rb"

class Problem < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_many :submissions, dependent: :destroy
  belongs_to :contest

  has_many_attached :problem_data
  validates :problem_data, presence: true, on: :create
  validate :correct_problem_data_extensions

  before_create :set_uuid
  before_destroy :delete_dataset

  DATASETS_PATH = "#{Rails.root}/datasets/"

  ##
  # Gets the problem description or a template to edit.
  #
  def get_description
    return description if description
    I18n.t('problems.description')
  end

  ##
  # Gets ancestors for the breadcrumb.
  #
  def get_ancestors(is_editing)
    ancestors = []
    
    # determine which path to return
    if is_editing
      path = edit_admin_contest_problem_path(contest, self)
    else
      path = problem_path(self)
    end

    ancestors << [name, path]
    ancestors += contest.get_ancestors(is_editing)
  end

  def delete_local_dataset
    cr = ConsoleRunner.new("rm -r #{DATASETS_PATH}#{uuid}")
    cr.finish
  end

  def prepare_dataset
    unless Dir.exist? "#{DATASETS_PATH}#{uuid}"
      create_dataset
    end
  end

  ##
  # Gets the problem data.
  #
  def get_data()
    if @test_data.nil?
      @test_data = Hash.new
      for f in Dir.glob("#{DATASETS_PATH}#{uuid}/*.in")
        @test_data[f] = f.chomp('.in') << '.out'
      end
    end

    @test_data
  end

  def get_sorted_scores
    users = Set.new
    for submission in submissions
      users << submission.user
    end

    sorted = []
    for user in users
      sorted << [user] + get_score(user)
    end

    sorted.sort_by! do |score|
      _, submission, _ = score
      submission.score
    end.reverse!
  end

  ##
  # Gets the top score of the user for the problem.
  #
  def get_score(user)
    if user.nil?
      return nil, I18n.t('problems.not_signed_in')
    end

    submissions = Submission.where(:user => user, :problem => self)
    if submissions.empty?
      return nil, I18n.t('problems.no_submissions_made')
    else
      submission = submissions.order('score DESC').first
      return submission, submission.get_formatted_score
    end
  end

  ##
  # Gets the maximum points which can be awarded for the problem.
  #
  def get_max_score
    get_data.length
  end

  private

  def correct_problem_data_extensions
    problem_data&.each do |datum|
      unless ['.in', '.out'].include? datum.filename.extension_with_delimiter
        datum.purge
      end
    end
  end

  ##
  # Initializes the problem UUID to avoid collisions between deleted problems and new ones.
  #
  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  ##
  # Creates a dataset folder for the problem.
  #
  def create_dataset
    cr = ConsoleRunner.new("mkdir -p #{DATASETS_PATH}#{uuid}")
    cr.finish

    @test_data = Hash.new
    for test_datum in problem_data
      file_path = "#{DATASETS_PATH}#{uuid}/#{test_datum.filename.sanitized}"

      File.open(file_path, "w") do |f|
        f.write(test_datum.download)
      end

      # link the output file with its respective input file
      if test_datum.filename.extension_with_delimiter == ".out"
        @test_data[file_path.chomp(".in") << ".out"] = file_path
      end
    end
  end

  ##
  # Deletes the dataset folder for the problem.
  #
  def delete_dataset
    problem_data.each { |datum| datum.purge }
    delete_local_dataset
  end
end
