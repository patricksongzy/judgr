class SubmissionsController < ApplicationController
  include SubmissionsHelper
  
  def show
    @submission = Submission.find(params[:id])
    authorize @submission

    @contest = @submission.problem.contest
  end

  def create
    @submission = Submission.new(submission_params)
    authorize @submission

    @submission.create(current_user)

    if @submission.valid?
      current_user.last_request = Time.now.to_i
      current_user.save!

      @submission.save!
      ProcessSubmissionJob.perform_later @submission

      redirect_to submission_path(@submission)
    else
      flash[:submission_error] = @submission.errors.full_messages
      flash.keep
      redirect_to request.referrer || root_path
    end
  end
end
