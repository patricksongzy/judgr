class ProblemsController < ApplicationController
  def index
    @problems = Problem.all
  end

  def show
    @problem = Problem.find(params[:id])
    @submission = Submission.new
    @submission.problem_id = @problem.id
  end
end
