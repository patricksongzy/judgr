class SubmissionsController < ApplicationController
  include SubmissionsHelper
  
  def show
    @submission = Submission.find(params[:id])
    authorize @submission
  end

  def create
    @submission = Submission.new(submission_params)
    authorize @submission

    @submission.create(current_user)

    if @submission.valid?
      @submission.process
      @submission.save!

      redirect_to submission_path(@submission)
    else
      flash[:submission_error] = @submission.errors.full_messages
      flash.keep
      redirect_to request.referrer
    end
  end
end
