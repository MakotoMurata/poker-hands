module V1
  class Root < Grape::API
    #localhost:3000//vi
    version :v1, :using => :path
    format :json

    mount V1::Cards
  end
end