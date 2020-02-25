class SubmissionsController < ApplicationController
  include SubmissionsHelper

  def index
    @submissions = Submission.all
  end
  
  def show
    @submission = policy_scope(Submission).find(params[:id])
  end

  def create
    @submission = Submission.new(submission_params)
    @submission.problem_id = params[:problem_id]
    @submission.user_id = current_user.id

    @submission.save!

    redirect_to problem_submissions_path(@submission)
  end
end
