module Base
  class API < Grape::API
    prefix "api"
    format :json
    route :any,'*path' do
      error!({error:"404 Not Found リソースがみつかりません"},404)
    end
    mount V1::Root
  end
end