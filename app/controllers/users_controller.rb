class UsersController < Clearance::UsersController
  def create
    @user = user_from_params
    @user.email_confirmation_token = Clearance::Token.new

    duplicate = User.where(email: @user.email).first
    duplicate.destroy unless duplicate.nil? or duplicate.confirmed?

    @user.verify_permitted

    if @user.errors.empty? and @user.save
      UserMailer.confirm_registration(@user).deliver_later
      redirect_back fallback_location: url_after_create, flash: { notice: I18n.t('users.unconfirmed_message') }
    else
      flash[:alert] = @user.errors.full_messages
      flash.keep
      render template: "users/new"
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email, :password, :password_confirmation)
  end
end
