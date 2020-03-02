class Admin::ContestsController < ApplicationController
  include ContestsHelper
  
  def new
    @contest = Contest.new
    authorize @contest
  end

  def create
    @contest = Contest.new(contest_params)
    authorize @contest

    @contest.save!

    redirect_to contest_path(@contest)
  end
end
