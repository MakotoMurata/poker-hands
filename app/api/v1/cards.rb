module V1
  class Cards < Grape::API
    include JudgeModule
    #localhost:3000/v1/cards
    resources :cards do
      desc '複数のカードセットを受け取り、card,hand,bestを配列として返すAPI'
      params do
        #配列の中身も指定すると、なおよし
        requires :cards, type: Array
      end
      post '/check' do
        card_set = params[:cards]
        cards = []
        card_set.each do |card|
          cards << HandsJudgeService.new(card: card)
        end
        hand_set =[]
        results = []
        errors = []

        cards.each do |card|
          hand_set << card.judge
          pp hand_set
          card.validate_check
          card.best_check(hand_set)
          if card.errors = true
            errors << [{card: card.card},{error:card.errors}]
          else
            results << [{card: card.card},{hand: card.hand},{best: card.best}]
          end
        end

        @errors = {error: errors}
        @result = {result: results}
        present @result, @errors
      end
    end
  end
end