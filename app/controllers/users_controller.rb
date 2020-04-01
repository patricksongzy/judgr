class UsersController < Clearance::UsersController
  def create
    @user = user_from_params
    @user.email_confirmation_token = Clearance::Token.new

    duplicate = User.where(email: @user.email).first
    duplicate.destroy unless duplicate.confirmed?

    if @user.save
      UserMailer.confirm_registration(@user).deliver_later
      flash[:notice] = I18n.t('users.unconfirmed_message')
      redirect_back_or url_after_create
    else
      flash[:alert] = @user.errors.full_messages
      render template: "users/new"
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email, :password, :password_confirmation)
  end
end
