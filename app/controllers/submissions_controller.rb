class SubmissionsController < ApplicationController
  include SubmissionsHelper
  
  def show
    @submission = Submission.find(params[:id])
    authorize @submission
  end

  def create
    @submission = Submission.new(submission_params)
    authorize @submission

    code_file = @submission.code_file
    language = Language.where(:extension => File.extname(code_file.original_filename)).first

    if language == nil
      redirect_to request.referrer, flash: {error: "unknown extension"}
      return
    end

    @submission.language_id = language.id
    @submission.code = code_file.read

    @submission.user_id = current_user.id

    @submission.process
    @submission.save!

    redirect_to submission_path(@submission)
  end
end
