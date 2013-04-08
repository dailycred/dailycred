Dailycred::Engine.routes.draw do
  get "/:provider/callback" => "sessions#create"
  get "/logout" => "sessions#destroy", :as => :logout
  get "/" => "sessions#info", :as => :auth_info
  # get "/dailycred", :as => :login
  get "/failure" => "sessions#failure"
end