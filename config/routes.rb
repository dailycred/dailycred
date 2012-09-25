Dailycred::Engine.routes.draw do
  match "/:provider/callback" => "sessions#create"
  match "/logout" => "sessions#destroy", :as => :logout
  match "/" => "sessions#info", :as => :auth_info
  # get "/dailycred", :as => :login
  match "/failure" => "sessions#failure"
end