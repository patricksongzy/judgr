require 'action_view'

class Contest < ApplicationRecord
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::DateHelper

  has_many :problems

  attr_accessor :start_date, :start_time, :end_date, :end_time
  validates :name, presence: true

  before_save :set_dates

  def get_ancestors(is_editing)
    ancestors = []

    if is_editing
      path = edit_admin_contest_path(self)
      index_path = admin_contests_path
    else
      path = contest_path(self)
      index_path = contests_path
    end

    ancestors << [name, path]
    ancestors << ["Contests", index_path]
  end

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

  def get_epoch(iso_date, time)
    DateTime.parse("#{iso_date} #{time}".strip).change(offset: (Time.now.utc_offset / 3600).to_s)
  end

  def get_iso(epoch)
    if epoch
      time = Time.at(epoch)
      return time.strftime("%Y-%m-%d"), time.strftime("%H:%M:%S")
    end
  end

  def get_human_dates
    now = Time.now.to_i
    time_to_start = distance_of_time_in_words_to_now(start_datetime)

    if end_datetime
      time_to_end = distance_of_time_in_words_to_now(end_datetime)
      end_message = now >= end_datetime ? " and closed #{time_to_end} ago" : " and closes in #{time_to_end}"
    end
    
    if now >= start_datetime
      "Contest opened #{time_to_start} ago#{end_message}."
    else
      "Contest opens in #{time_to_start}#{end_message}."
    end
  end

  def get_start
    unless start_datetime.nil?
      get_iso(start_datetime)
    end
  end

  def get_end
    unless end_datetime.nil?
      get_iso(end_datetime)
    end
  end

  private

  def set_dates
    if start_date.empty?
      self.start_datetime = Time.now.to_i
    else
      self.start_datetime = get_epoch(start_date, start_time)
    end

    unless end_date.empty?
      self.end_datetime = get_epoch(end_date, end_time)
    end
  end
end
