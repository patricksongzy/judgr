class Contest < ApplicationRecord
  has_many :problems

  attr_accessor :start_date, :start_time, :end_date, :end_time

  def get_user_score(user)
    total_score = 0
    max_score = 0

    for problem in problems
      score, problem_max_score, _ = problem.get_problem_score(user)
      total_score += score
      max_score += problem_max_score
    end

    return total_score, max_score, "#{total_score} / #{max_score}"
  end

  def get_start
    if start_datetime.nil?
      "N/A"
    end
  end

  def get_end
    if end_datetime.nil?
      "N/A"
    end
  end
end
