Dailycred::Engine.routes.draw do
  get "/:provider/callback" => "dailycred/sessions#create"
  get "/logout" => "dailycred/sessions#destroy", :as => :logout
  get "/" => "dailycred/sessions#info", :as => :auth_info
  # get "/dailycred", :as => :login
  get "/failure" => "dailycred/sessions#failure"
  get "/reset_password" => "dailycred/users#reset_password"
  post "/" => "dailycred/users#signup", as: :local_signup
  post "/login" => "dailycred/users#login", as: :local_login
end