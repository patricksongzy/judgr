class Admin::ProblemsController < ApplicationController
  def new
    @problem = Problem.new
    authorize @problem
  end
end
