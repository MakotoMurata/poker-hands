module API
    module V1
      class Cards < Grape::API
        resource :cards do
          desc ''
          params do
          requires :cards ,type: Array
          end
          include JudgeModule
          post '/check' do
            cards_set = params[:cards]
            cards = []
            cards_set.each do |card_set|
              cards << HandsJudgeService.new(hand: card_set)
            end

            # cards.each do |card|
            #   card.judge
            # end
            #
            # # hand_results << card.judge
            # strength_set = []
            # strength_set << hand_results.keys.to_i
            # strongest_number = strength_set.max
            #
            # #bestって配列を用意
            # #resultsの数だけ繰り返し処理を行い、resultsのキーの番号と、strongest_numberが同じならば、Bestにtrueを、違ったらBestにfalseを入れこむ
            # best = []
            # results.each do |result|
            #   #resultsのキーの番号と、strongest_numberが同じ　
            #   if
            #     best << true
            #   #resultsのキーの番号と,strongest_numberが同じ
            #   elsif
            #     best << false
            #   end
          end

              #変数resultsにcard、hand,bestをキーにもち、それぞれの結果をバリューとしてもつ、配列を代入していく
          #     x =
          #   results = []
          #   render json: {result: results}
          # end
        end
      end
    end
  end
