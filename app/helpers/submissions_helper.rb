module SubmissionsHelper
  def submission_params
    params.require(:submission).permit(:code, :language_id, :problem_id, :code_file)
  end

  def flash_errors
    flash[:submission_error] = @submission.errors.full_messages
    flash.keep
    redirect_to request.referrer || root_path
  end
end
