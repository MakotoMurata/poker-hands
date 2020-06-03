module V1
  class Cards < Grape::API
    #localhost:3000/v1/cards
    resources :cards do
      params do
        requires :cards, type:Array
      end

      post '/check' do
        card_set = params[:cards]
        card_set.each do |crd|
          @card = HandsJudgeService.new(card: crd)
        end
        card.judge
        @card.validate_check
        #インスタンスを配列に持つ@cardをベストな手札かどうか判断するメソッドを通す
      end
      # #presentで値を返す
      # # @result =　card,result,bestという@card(インスタンス)が持つインスタンス変数を一つの配列にまとめたものを繰り返し処理する
      # present @result, with: V1::Entities::CardsEntity
    end
  end
end