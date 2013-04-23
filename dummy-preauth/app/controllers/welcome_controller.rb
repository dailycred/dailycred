class WelcomeController < ApplicationController
  def index
    if logged_in?
      render json: current_user
    else
      render text: 'hello'
    end
  end
end
