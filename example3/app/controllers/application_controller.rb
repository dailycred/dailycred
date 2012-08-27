class ApplicationController < ActionController::Base
  helper_method :current_user

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
  helper_method :current_user

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
  protect_from_forgery
end
