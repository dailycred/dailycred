class SessionsController < ApplicationController
  before_filter :authenticate, :only => [:destroy]
  before_filter :current_user

  # Callback Route for OAuth flow
  def create
    @user = User.find_by_provider_and_uid(auth_hash['provider'], auth_hash['uid']) || User.create_with_omniauth(auth_hash)
    session[:user_id] = @user.id
    redirect_to auth_path
  end

  #GET /logout
  def destroy
    session[:user_id] = nil
    redirect_to auth_path
  end

  #POST /auth
  #POST /auth.json
  def authenticate
    @user = Dailycred::User.new(params[:user])

    respond_to do |f|

    end
  end

  def info

  end

  private
  def auth_hash
    request.env['omniauth.auth']
  end
end

