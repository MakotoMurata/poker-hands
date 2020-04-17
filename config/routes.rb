Rails.application.routes.draw do
  post "/check" => "home#check"
  get "/" => "home#top"
  get "/show" => "home#show"
  get "/error" => "home#error"  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
