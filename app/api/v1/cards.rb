module V1
  class Cards < Grape::API
    require_relative '../../services/judge_service'
    include JudgeModule
    resources :cards do
      desc 'JSON形式で正しいエンドポイントにリクエストされたとき'
      params do
        requires :cards, type: Array
      end
      post '/check' do
        #複数のカードの配列をcard_setで受け取る
        card_set = params[:cards]
        #card_setを繰り返し処理かけて、cardsという配列にインスタンスを入れていく
        cards = []
        card_set.each do |card|
          cards << HandsJudgeService.new(card: card)
        end

        #cardsに繰り返し処理をかける
        parameters =[]
        cards.each do |card|
          #それぞれのインスタンスが持つカードに不正があれば、errorsというインスタンス変数を持つようにする
          if card.validate_check
            #それぞれのインスタンスが持つカードに不正がなければ、役判定をかけていく
          else
            #handというインスタンス変数に役の情報を入れていく
            card.judge
            #判定した役のインデックス番号をparameterというインスタンス変数に代入し、それをまとめたparametersという配列を作る
            parameters << card.get_parameter(card.hand)
          end
        end
        #parametersの配列を用いて、それぞれの役が一番強いかどうかを判定し、一番強い役にbest=true,
        cards.each do |card|
          card.best_hand_check(parameters,card.parameter)
        end

        errors = []
        results = []
        #カードに不正がありhandに役が入っていないインスタンスは、情報をerrorsに配列として入れていく
        cards.each do |card|
          if card.hand == nil
            errors << {card: card.card,msg:card.errors}
            @errors = {error: errors}
          else
            #カードが正常でhandに役が入っているインスタンスは、情報をresultsに配列として入れていく
            results << {card: card.card,hand: card.hand,best: card.best}
            @results = {result: results}
          end
        end

        #間違ったカード入力が１つもない場合はresultだけを表示
        if @errors == nil
          present @results
          #正しいカード入力が一つもない場合はerrorだけを表示
        elsif @results == nil
          present @errors
        else
          #間違ったカード入力と正しいカード入力が混ざっている場合はどちらも表示
          @all_results = {result:results,error:errors}
          present @all_results
        end
      end
    end
  end
end