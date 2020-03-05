class ContestsController < ApplicationController
  def index
    @contests = policy_scope(Contest).all
  end

  def show
    @contest = Contest.find(params[:id])
    authorize @contest

    @submission = Submission.new
  end
end

