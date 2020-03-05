class Admin::ProblemsController < ApplicationController
  include ProblemsHelper

  before_action :require_login

  def create
    @problem = Problem.new(problem_params)
    authorize [:admin, @problem]

    @problem.contest_id = params[:contest_id]
    @problem.save!

    redirect_to problem_path(@problem)
  end
end
