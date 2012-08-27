class SessionsController < ApplicationController
  before_filter :authenticate, :only => [:destroy]

  def create
    @user = User.find_by_provider_and_uid(auth_hash['provider'], auth_hash['uid']) || User.create_with_omniauth(auth_hash)
    session[:user_id] = @user.id
    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end

  private
  def auth_hash
    request.env['omniauth.auth']
  end
end

