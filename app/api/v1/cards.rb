module V1
  class Cards < Grape::API
    require_relative '../../services/judge_service'
    include JudgeModule
    resources :cards do
      desc 'ポーカーの手札の情報を受け取り、役名とその中でもっとも役名を返却する'
      params do
        requires :cards, type: Array[String]
      end
      post '/check' do
        cards_set = params[:cards]
        card_set = []
        cards_set.each do |cards|
          card_set << HandsJudgeService.new(cards)
        end
        max_power = 0
        card_set.each do |card|
         if  card.valid_check?
           card.judge
           max_power = card.hand_power if card.hand_power > max_power
         end
        end
        errors = []
        results = []
        card_set.each do |card|
          card.best = true if card.hand_power == max_power
          if card.errors.present?
            errors << {card: card.card, msg: card.errors}
          else
            results << {card: card.card, hand: card.hand, best: card.best}
          end
        end
        @all_results = {}
        @all_results["result"] = results if results.present?
        @all_results["error"] = errors if errors.present?
        present @all_results
      end
    end
  end
end
