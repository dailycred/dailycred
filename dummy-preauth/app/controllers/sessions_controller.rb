class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:login], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to_target_or_default root_url, :notice => "Logged in successfully."
    else
      flash.now[:alert] = "Invalid login or password."
      render :action => 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "You have been logged out."
  end

  def callback
    auth_hash = request.env['omniauth.auth']
    if auth_hash['uid']
      @user = User.find_or_create_by(uuid: auth_hash['uid'])
      @user.uuid = auth_hash['uid']
      @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Logged in successfully."
    else
      flash[:notice] = "There was an error logging you in."
    end
    redirect_to_target_or_default root_url
  end
end
