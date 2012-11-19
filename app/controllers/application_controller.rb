class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def not_authenticated
  	redirect_to signin_url, alert: "First signin to access previous page."
  end
end
