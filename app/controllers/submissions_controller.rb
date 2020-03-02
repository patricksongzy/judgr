class SubmissionsController < ApplicationController
  include SubmissionsHelper
  
  def show
    @submission = Submission.find(params[:id])
    authorize @submission
  end

  def create
    @submission = Submission.new(submission_params)
    authorize @submission

    @submission.user_id = current_user.id

    @submission.save!

    redirect_to submission_path(@submission)
  end
end
