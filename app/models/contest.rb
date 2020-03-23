require 'action_view'

class Contest < ApplicationRecord
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::DateHelper

  has_many :problems

  attr_accessor :start_date, :start_time, :end_date, :end_time
  validates :name, presence: true

  before_save :set_dates

  ##
  # Gets ancestors for the breadcrumb.
  #
  def get_ancestors(is_editing)
    ancestors = []

    # determine which paths to return
    if is_editing
      path = edit_admin_contest_path(self)
      index_path = admin_contests_path
    else
      path = contest_path(self)
      index_path = contests_path
    end

    ancestors << [name, path]
    # contest is the last level of paths to return
    ancestors << [Contest.model_name.human(count: :many), index_path]
  end

  ##
  # Gets the user's cumulative score for the contest.
  #
  def get_score(user)
    total_score = 0
    max_score = 0

    for problem in problems
      score, problem_max_score, _ = problem.get_score(user)
      total_score += score
      max_score += problem_max_score
    end

    return total_score, max_score, "#{total_score} / #{max_score}"
  end

  ##
  # Gets the epoch from an ISO date and time.
  #
  def get_epoch(iso_date, time)
    DateTime.parse("#{iso_date} #{time}".strip).change(offset: (Time.now.utc_offset / 3600).to_s)
  end

  ##
  # Gets the ISO formatted date from epoch.
  #
  def get_iso(epoch)
    if epoch
      time = Time.at(epoch)
      return time.strftime("%Y-%m-%d"), time.strftime("%H:%M:%S")
    end
  end

  ##
  # Display contest open and close information in a human readable way.
  #
  def get_human_dates
    now = Time.now.to_i
    time_to_start = distance_of_time_in_words_to_now(start_datetime)

    # some contests do not have a close date
    if end_datetime
      time_to_end = distance_of_time_in_words_to_now(end_datetime)
      end_message = now >= end_datetime ? " #{I18n.t 'contests.and_closed_time_ago', time_to: time_to_end}" : " #{I18n.t 'contests.and_closes_in_time', time_to: time_to_end}"
    end
    
    if now >= start_datetime
      "#{I18n.t 'contests.opened_time_ago', time_to: time_to_start}#{end_message}."
    else
      "#{I18n.t 'contests.opens_in_time', time_to: time_to_start}#{end_message}."
    end
  end

  ##
  # Gets the ISO start date and time.
  #
  def get_start
    unless start_datetime.nil?
      get_iso(start_datetime)
    end
  end

  ##
  # Gets the ISO end date and time.
  #
  def get_end
    unless end_datetime.nil?
      get_iso(end_datetime)
    end
  end

  ##
  # Gets the status of the contest.
  #
  def get_status
    has_ended? ? I18n.t('contests.closed') : has_started? ? I18n.t('contests.open') : I18n.t('contests.scheduled')
  end

  ##
  # Checks whether the contest is accepting submissions.
  #
  def is_open?
    has_started? and not has_ended?
  end

  ##
  # Check whether the contest will begin accepting submissions in the future.
  #
  def is_scheduled?
    not (has_started and has_ended)
  end

  ##
  # Check whether the current date and time is past the contest's start date and time.
  #
  def has_started?
    return true if start_datetime.nil?

    now = Time.now.to_i
    now >= start_datetime
  end

  ##
  # Checks whether the contest has ended.
  #
  def has_ended?
    return false if end_datetime.nil?

    now = Time.now.to_i
    now >= end_datetime
  end

  private

  ##
  # Initializes the start and end epochs from dates and times selected from fields.
  #
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
