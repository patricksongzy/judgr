class ContestsController < ApplicationController
  include ContestsHelper

  def index
    @contests = get_contests_ordered(policy_scope(Contest).all)
  end

  def show
    @contest = Contest.find(params[:id])
    authorize @contest

    @submission = Submission.new
  end
end

