class Admin::ContestsController < ApplicationController
  include ContestsHelper

  def index
    @contests = Contest.all
    authorize [:admin, @contests]
  end
  
  def new
    @contest = Contest.new
    authorize [:admin, @contest]
  end

  def create
    @contest = Contest.new(contest_params)
    authorize [:admin, @contest]

    @contest.save!

    redirect_to contest_path(@contest)
  end

  def edit
    @contest = Contest.find(params[:id])
    authorize [:admin, @contest]

    @problem = Problem.new
    authorize [:admin, @problem]
  end

  def update
    @contest = Contest.find(params[:id])
    authorize [:admin, @contest]

    @contest.update(contest_params)

    redirect_to contest_path(@contest)
  end

  def destroy
    @contest = Contest.find(params[:id])
    authorize [:admin, @contest]
  end
end
