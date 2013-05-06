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
  end
end