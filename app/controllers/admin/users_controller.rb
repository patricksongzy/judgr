class Admin::UsersController < ApplicationController
  include Admin::UsersHelper

  def index
    @users = User.all
    authorize [:admin, @users]
  end

  def update
    @user = User.find(params[:id])
    authorize [:admin, @user]

    @user.update(user_params)
    # log the user out to reflect changes
    @user.reset_remember_token!

    redirect_to action: "index"
  end
end
