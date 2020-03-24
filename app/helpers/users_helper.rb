module UsersHelper
  def user_params
    params.require(:user).permit(:is_suspended)
  end
end
