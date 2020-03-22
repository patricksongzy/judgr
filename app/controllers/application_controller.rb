class ApplicationController < ActionController::Base
  protect_from_forgery

  include Clearance::Controller
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :unauthorized

  private

  def unauthorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    flash[:application_error] = t("#{policy_name}.#{exception.query}", scope: "pundit", default: :default)
    redirect_to(request.referrer || root_path)
  end
end
