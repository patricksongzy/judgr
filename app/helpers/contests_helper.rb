module ContestsHelper
  def contest_params
    params.require(:contest).permit(:name, :start_date, :start_time, :end_date, :end_time)
  end

  def get_contests_ordered(contests)
    open, closed = contests.partition { |contest| contest.is_open? }
    open.sort_by { |contest| contest.start_datetime }.reverse + closed.sort_by { |contest| contest.end_datetime || contest.start_datetime }.reverse
  end
end
