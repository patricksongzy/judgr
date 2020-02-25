class ProblemsController < ApplicationController
  def index
    @problems = policy_scope(Problem).all
  end

  def show
    @problem = Problem.find(params[:id])
    authorize @problem

    @submission = Submission.new
    @submission.problem_id = @problem.id
  end
end
