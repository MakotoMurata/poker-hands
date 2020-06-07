module V1
  class Root < Grape::API
    version :v1, :using => :path
    format :json
    #リクエストされたパラメータが不正な場合
    rescue_from Grape::Exceptions::Base do
      error!({error:"400 Bad request リクエストデータに不正があります"},400)
    end
    #不正なurlにアクセスした場合
    route :any,'*path' do
      error!({error:"404 Not Found リソースがみつかりません"},404)
    end
    # インターナルサーバーエラー
    rescue_from :all do
      error!({error:"500 Internal Server Error 内部でエラーが起きています"},500)
    end
    mount V1::Cards
  end
end
