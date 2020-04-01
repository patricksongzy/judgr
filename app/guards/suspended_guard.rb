class SuspendedGuard < Clearance::SignInGuard
  def call
    if signed_in? and current_user.is_suspended?
      failure(I18n.t 'users.suspended_message')
    else
      next_guard
    end
  end
end

