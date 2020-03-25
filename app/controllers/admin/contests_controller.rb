require 'date'

class Admin::ContestsController < ApplicationController
  include ContestsHelper
  include Admin::ContestsHelper

  before_action :require_login

  def index
    all_unordered = Contest.all
    authorize [:admin, all_unordered]

    @contests = get_contests_ordered(all_unordered)

    @contest = Contest.new
    authorize [:admin, @contest]
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

    @contest.start_date, @contest.start_time = @contest.get_start
    @contest.end_date, @contest.end_time = @contest.get_end

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

    @contest.destroy
    redirect_to action: "index"
  end
end
