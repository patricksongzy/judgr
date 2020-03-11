class SubmissionsController < ApplicationController
  include SubmissionsHelper
  
  def show
    @submission = Submission.find(params[:id])
    authorize @submission
  end

  def create
    @submission = Submission.new(submission_params)
    authorize @submission

    code_file = params[:submission][:code_file]
    @submission.language_id = Language.where(:extension => File.extname(code_file.original_filename)).first.id
    @submission.code = code_file.read

    @submission.user_id = current_user.id

    @submission.save!
    @submission.process

    redirect_to submission_path(@submission)
  end
end
