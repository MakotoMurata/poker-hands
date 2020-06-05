module V1
  class Root < Grape::API
    rescue_from Root
    #localhost:3000/v1
    version :v1, :using => :path
    format :json

    mount V1::Cards
  end
end