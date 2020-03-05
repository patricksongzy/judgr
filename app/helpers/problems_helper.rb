module ProblemsHelper
  def problem_params
    params.require(:problem).permit(:name, :description)
  end
end
