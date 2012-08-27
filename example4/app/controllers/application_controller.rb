class ApplicationController < ActionController::Base
  helper_method :current_user, :login_path, :dailycred

  private

  def current_user
    begin
      @current_user || User.find(session[:user_id]) if session[:user_id]
    rescue
      nil
    end
  end

  def authenticate
    redirect_to :root unless current_user
  end

  def login_path
    "/auth/dailycred"
  end

  def dailycred
    config = Rails.configuration
    @dailycred ||= Dailycred.new(config.dailycred_client_id, config.dailycred_secret_key)
  end
  protect_from_forgery
end
