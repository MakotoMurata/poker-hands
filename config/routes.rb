Rails.application.routes.draw do
  post "/check" => "cards#check"
  get "/check" => "cards#check"
  get "/" => "cards#top"
  get "/result" => "cards#result"
  get "/error" => "cards#error"

  mount Base::API => '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
