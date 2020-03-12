class Admin::ProblemsController < ApplicationController
  include ProblemsHelper

  before_action :require_login

  def edit
    @problem = Problem.find(params[:id])
    authorize [:admin, @problem]

    @contest = @problem.contest
  end

  def update
    @problem = Problem.find(params[:id])
    authorize [:admin, @problem]

    @problem.update(problem_params)

    @problem.create_dataset(params[:problem][:problem_data])

    redirect_to problem_path(@problem)
  end

  def create
    @problem = Problem.new(problem_params)
    authorize [:admin, @problem]

    @problem.contest_id = params[:contest_id]
    @problem.save!

    @problem.create_dataset(params[:problem][:problem_data])

    redirect_to problem_path(@problem)
  end

  def destroy
    @problem = Problem.find(params[:id])
    authorize [:admin, @problem]

    contest = @problem.contest

    @problem.destroy
    redirect_to edit_admin_contest_path(contest)
  end
end
