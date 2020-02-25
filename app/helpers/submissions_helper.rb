module SubmissionsHelper
  def submission_params
    params.require(:submission).permit(:code, :language_id, :problem_id)
  end
end
