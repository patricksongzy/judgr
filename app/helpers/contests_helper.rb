module ContestsHelper
  def contest_params
    params.require(:contest).permit(:name, :start_date, :start_time, :end_date, :end_time)
  end
end
