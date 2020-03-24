class ApplicationController < ActionController::Base
  protect_from_forgery

  include Clearance::Controller
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :unauthorized

  private

  def unauthorized(exception)
    flash[:application_error] = t(exception, scope: "pundit", default: :default)
    redirect_to(request.referrer || root_path)
  end
end
