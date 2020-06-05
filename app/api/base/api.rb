module Base
  class API < Grape::API
    rescue_from API
    format :json
    mount V1::Root
  end
end