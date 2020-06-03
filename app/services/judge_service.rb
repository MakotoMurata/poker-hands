module JudgeModule
  class HandsJudgeService
    include ActiveModel::Model

    require_relative ("const/poker_hand_definition")
    include HandsModule

    attr_accessor :card, :hand, :errors, :best

    def judge
      suits = card.delete("^A-Z| ").split(" ")
      nums = card.delete("^0-9| ").split(" ").map(&:to_i)

      if suits.count(suits[0]) == suits.length
        flush = true
      else
        flush = false
      end

      if nums.sort[1] == nums.sort[0] +1 && nums.sort[2] == nums.sort[0] + 2 && nums.sort[3] == nums.sort[0] +3 && nums.sort[4] == nums.sort[0] + 4 || nums.sort == [1,10,11,12,13]
        straight = true
      else
        straight = false
      end

      count_box = []
      dup_num = nums.uniq
      dup_num.each do |x|
        count_box << nums.count(x)
      end

      dupilicate = count_box.sort.reverse
      case [dupilicate, straight, flush]
      when [[1,1,1,1,1], true, true]
          @hand = HANDS[8][:straight_flush]
      when [[1,1,1,1,1], true, false]
          @hand = HANDS[4][:straight]
      when [[1,1,1,1,1], false, true]
          @hand = HANDS[5][:flush]
      when [[1,1,1,1,1], false, false]
          @hand = HANDS[0][:high_card]
      when [[4,1], false, false]
          @hand = HANDS[7][:four_cards]
      when [[3,2], false, false]
          @hand = HANDS[6][:full_house]
      when [[3,1,1], false, false]
          @hand = HANDS[3][:three_cards]
      when [[2,2,1], false, false]
          @hand = HANDS[2][:two_pair]
      when [[2,1,1,1],false, false]
          @hand = HANDS[1][:one_pair]
      else
      end
    end

    def validate_check
      @errors = []
      cards = card.split(" ")
      if card.empty?
        @errors << "5つのカード指定文字{半角英字(S,D,C,H)と半角数字(1~13)を組み合わせたもの}を半角スペース区切りで入力してください。(例: S1 H3 D9 C13 S11)"
      elsif cards.size - cards.uniq.size != 0
        @errors << "カードが重複しています"
      elsif card !~ /\A[SDCH]([1-9]|1[0-3]) [SDCH]([1-9]|1[0-3]) [SCDH]([1-9]|1[0-3]) [SCDH]([1-9]|1[0-3]) [SCDH]([1-9]|1[0-3])\z/
        @errors << "5つのカード指定文字{半角英字(S,D,C,H)と半角数字(1~13)を組み合わせたもの}を半角スペース区切りで入力してください。(例: S1 H3 D9 C13 S11)"
        cards.each_with_index do |card,idx|
        index = idx +1
          if card !~  /\A[SDCH]([1-9]|1[0-3])\z/
            @errors << "#{index}番目のカードが不正です(#{card})"
          end
        end
      end
    end

    def best_check(hand_set)
      str_parameters = hand_set.keys
      strongest_number = str_parameters.max
      hand_set.each do |hand|
        if strongest_number == hand.key
          @best = "true"
        else
          @best = "false"
        end
      end
    end
  end
end
