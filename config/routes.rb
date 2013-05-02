Dailycred::Engine.routes.draw do
  get "/:provider/callback" => "dailycred/sessions#create"
  get "/logout" => "dailycred/sessions#destroy", :as => :logout
  get "/" => "dailycred/sessions#info", :as => :auth_info
  # get "/dailycred", :as => :login
  get "/failure" => "dailycred/sessions#failure"
end