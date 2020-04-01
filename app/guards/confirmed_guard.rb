class ConfirmedGuard < Clearance::SignInGuard
  def call
    if signed_in? and not current_user.confirmed?
      failure(I18n.t('users.unconfirmed_message'))
    else
      next_guard
    end
  end
end

