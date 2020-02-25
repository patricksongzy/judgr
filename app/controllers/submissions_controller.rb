class SubmissionsController < ApplicationController
  include SubmissionsHelper
  
  def show
    @submission = policy_scope(Submission).find(params[:id])
  end

  def create
    @submission = Submission.new(submission_params)
    authorize @submission
    @submission.problem_id = params[:problem_id]
    @submission.user_id = current_user.id

    @submission.save!

    redirect_to problem_submission_path(params[:problem_id], @submission)
  end
end
