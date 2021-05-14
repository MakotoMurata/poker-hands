module V1
  class Root < Grape::API
    version :v1, :using => :path
    format :json
    rescue_from Grape::Exceptions::Base do
      error!({error:"400 Bad request リクエストデータに不正があります"},400)
    end
    rescue_from :all do
      error!({error:"500 Internal Server Error 内部でエラーが起きています"},500)
    end
    mount V1::Cards
  end
end
