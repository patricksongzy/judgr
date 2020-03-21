require 'date'

class Admin::ContestsController < ApplicationController
  include ContestsHelper

  before_action :require_login

  def index
    @contests = Contest.all
    authorize [:admin, @contests]

    @contest = Contest.new
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

    @contest.start_date, @contest.start_time = @contest.get_start
    @contest.end_date, @contest.end_time = @contest.get_end

    @problem = Problem.new
    authorize [:admin, @problem]
  end

  def update
    @contest = Contest.find(params[:id])
    authorize [:admin, @contest]

    @contest.update(contest_params)
    puts contest_params

    redirect_to contest_path(@contest)
  end

  def destroy
    @contest = Contest.find(params[:id])
    authorize [:admin, @contest]

    @contest.destroy
    redirect_to action: "index"
  end
end
