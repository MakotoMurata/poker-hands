module V1
  class Cards < Grape::API
    require_relative '../../services/judge_service'
    include JudgeModule
    require_relative '../../services/const/poker_hand_definition'
    include HandsModule
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
        powers = []
        card_set.each do |card|
          if card.card_invalid?
          else
            card.judge
            powers << card.hand_power
          end
        end
        errors = []
        results = []
        card_set.each do |card|
          if card.hand_power == powers.max
            @best = true
          else
            @best = false
          end
          if card.card_invalid?
            errors << {card: card.card,msg:card.errors}
            @errors = {error: errors}
          else
            results << {card: card.card,hand: card.hand,best: @best}
            @results = {result: results}
          end
        end
        if @errors.nil?
          present @results
        elsif @results.nil?
          present @errors
        else
          @all_results = {result: results, error: errors}
          present @all_results
        end
      end
    end
  end
end
