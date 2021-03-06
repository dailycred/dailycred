module Dailycred
  class UsersController < ApplicationController
    include Dailycred::Helpers

    def reset_password
      if params[:user]
        dailycred.reset_password(params[:user])
        flash[:notice] = "Your password has been reset. See your email for further instructions."
      else
        flash[:notice] = "Please enter your email or password to continue."
      end
      redirect_to_auth
    end

    def login
      response = dailycred.login params
      if response.success?
        @user = User.find_or_create_from_local_auth(response.user)
        session[:user_id] = @user.id
        flash[:notice] = "You have logged in successfully."
      else
        flash[:notice] = "There was a problem logging you in."
        flash[:login_error] = response.errors["message"]
        flash[:login_error_attribute] = response.errors["attribute"]
      end
      redirect_to_auth
    end

    def signup
      response = dailycred.signup params
      if response.success?
        @user = User.find_or_create_from_local_auth(response.user)
        session[:user_id] = @user.id
        flash[:notice] = "You have signed up successfully."
      else
        flash[:notice] = "There was a problem logging you in."
        flash[:signup_error] = response.errors["message"]
        flash[:signup_error_attribute] = response.errors["attribute"]
      end
      redirect_to_auth
    end
  end
end