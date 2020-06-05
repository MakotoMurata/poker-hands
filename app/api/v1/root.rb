module V1
  class Root < Grape::API
    #localhost:3000/v1
    version :v1, :using => :path
    format :json

    #リクエストされたパラメータが不正な場合
    rescue_from Grape::Exceptions::Base do
      error!({error:"400 Bad request リクエストデータに不正があります"},400)
    end
    route :any,'*path' do
      error!({error:"404 Not Found リソースがみつかりません　出直してこいバーカ"},404)
    end

    mount V1::Cards

  end
end