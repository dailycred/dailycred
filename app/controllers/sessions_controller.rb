class SessionsController < ApplicationController
  before_filter :authenticate, :only => [:destroy]
  before_filter :current_user

  # Callback Route for OAuth flow
  def create
    @user = User.find_or_create_with_omniauth auth_hash
    session[:user_id] = @user.id
    redirect_to_auth
  end

  #GET /logout
  def destroy
    session[:user_id] = nil
    redirect_to_unauth
  end

  def failure
    redirect_to_unauth notice: params[:message]
  end

  def info
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
