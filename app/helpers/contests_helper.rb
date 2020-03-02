module ContestsHelper
  def contest_params
    params.require(:contest).permit(:name)
  end
end
