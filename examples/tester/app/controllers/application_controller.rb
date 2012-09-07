class ApplicationController < ActionController::Base
  helper_method :current_user, :login_path, :dailycred, :signup_path

  private

  def current_user
    begin
      @current_user || User.find(session[:user_id]) if session[:user_id]
    rescue
      nil
    end
  end

  def authenticate
    redirect_to auth_path unless current_user
  end

  def signup_path
    "/auth/dailycred"
  end

  def login_path
    "/auth/dailycred?action=signin"
  end

  def dailycred
    config = Rails.configuration
    @dailycred ||= Dailycred.new(config.DAILYCRED_CLIENT_ID, config.DAILYCRED_SECRET_KEY, config.dc_client_opts)
  end
  protect_from_forgery
end
