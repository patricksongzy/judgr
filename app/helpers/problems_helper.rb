module ProblemsHelper
  def problem_params
    params.require(:problem).permit(:name, :description, :problem_data => [])
  end
end
