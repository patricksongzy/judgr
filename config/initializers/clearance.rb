class SuspendedGuard < Clearance::SignInGuard
  def call
    if current_user.is_suspended?
      failure(I18n.t 'users.suspended')
    else
      next_guard
    end
  end
end

Clearance.configure do |config|
  config.routes = false
  config.mailer_sender = "reply@example.com"
  config.rotate_csrf_on_sign_in = true
  config.redirect_url = "/contests"
  config.allow_sign_up = true
  config.cookie_path = "/"
  config.cookie_domain = "localhost"
  config.cookie_expiration = lambda { |cookies| 1.year.from_now.utc }
  config.cookie_name = "remember_token"
  config.sign_in_guards = [SuspendedGuard]
end
