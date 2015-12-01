class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	include Pundit
	
	rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
	before_action :configure_devise_permitted_parameters, if: :devise_controller?

  protected

  def configure_devise_permitted_parameters
		devise_parameter_sanitizer.for(:sign_up) << :username << :upgraded_at << :downgraded_at
  end
  
  private
  
  def user_not_authorized
  	flash[:error] = "You are not authorized to do this."
  	redirect_to(request.referer || root_path)
  end
  
end
