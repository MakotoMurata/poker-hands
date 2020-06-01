module JudgeModule
  class HandsJudgeService
    include ActiveModel::Model
    require_relative ("const/poker_hand_definition")
    include HandsModule
    attr_accessor :hand, :result, :errors
    def judge
      suits = hand.delete("^A-Z| ").split(" ")
      nums = hand.delete("^0-9| ").split(" ").map(&:to_i)

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

      dupilication = count_box.sort.reverse
      case [dupilication, straight, flush]
      when [[1,1,1,1,1], true, true]
          @result = HANDS[8][:straight_flush]
      when [[1,1,1,1,1], true, false]
          @result = HANDS[4][:straight]
      when [[1,1,1,1,1], false, true]
          @result = HANDS[5][:flush]
      when [[1,1,1,1,1], false, false]
          @result = HANDS[0][:highcard]
      when [[4,1], false, false]
          @result = HANDS[7][:four_cards]
      when [[3,2], false, false]
          @result = HANDS[6][:full_house]
      when [[3,1,1], false, false]
          @result = HANDS[3][:three_cards]
      when [[2,2,1], false, false]
          @result = HANDS[2][:two_pair]
      when [[2,1,1,1],false, false]
          @result = HANDS[1][:one_pair]
      else
      end
    end

    def validate_check
      @errors = []
      cards = hand.split(" ")
      if hand.empty?
        @errors << "5つのカード指定文字{半角英字(S,D,C,H)と半角数字(1~13)を組み合わせたもの}を半角スペース区切りで入力してください。(例: S1 H3 D9 C13 S11)"
      elsif cards.size - cards.uniq.size != 0
        @errors << "カードが重複しています"
      elsif hand !~ /\A[SDCH]([1-9]|1[0-3]) [SDCH]([1-9]|1[0-3]) [SCDH]([1-9]|1[0-3]) [SCDH]([1-9]|1[0-3]) [SCDH]([1-9]|1[0-3])\z/
        @errors << "5つのカード指定文字{半角英字(S,D,C,H)と半角数字(1~13)を組み合わせたもの}を半角スペース区切りで入力してください。(例: S1 H3 D9 C13 S11)"
        cards.each_with_index do |card,idx|
        index = idx +1
          if card !~  /\A[SDCH]([1-9]|1[0-3])\z/
            @errors << "#{index}番目のカードが不正です(#{card})"
          end
        end
      end
    end

    # def best_hand_check(cards)
    #   strength_parametes =
    #   strongest_number = strength_parametes.max
    #   strength_parametes.each do |x|
    #     if strongest_number == x
    #       best = true
    #     elsif strongest_number != hands_set[key]
    #       best = false
    #     end
    #   end
    # end
  end
end
