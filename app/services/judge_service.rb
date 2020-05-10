module JudgeModule
  class HandsJudgeService
    include ActiveModel::Model
    require_relative ("const/poker_hand_definition")
    include HandsModule
    attr_accessor :hand
    attr_reader :result
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
          @result = HANDS[:straight_flush]
      when [[1,1,1,1,1], true, false]
          @result = HANDS[:straight]
      when [[1,1,1,1,1], false, true]
          @result = HANDS[:flush]
      when [[1,1,1,1,1], false, false]
          @result = HANDS[:highcard]
      when [[4,1], false, false]
          @result = HANDS[:four_cards]
      when [[3,2], false, false]
          @result = HANDS[:full_house]
      when [[3,1,1], false, false]
          @result = HANDS[:three_cards]
      when [[2,2,1], false, false]
          @result = HANDS[:two_pair]
      when [[2,1,1,1],false, false]
          @result = HANDS[:one_pair]
      else
      end
    end

    validate :validate_check
    def validate_check
      cards = hand.split(" ")
      if hand.blank?
        errors[:base] << "5つのカード指定文字{半角英字(S,D,C,H)と半角数字(1~13)を組み合わせたもの}を半角スペース区切りで入力してください。(例: S1 H3 D9 C13 S11)"
      elsif hand !~ /\A[SDCH]([1-9]|1[0-3]) [SDCH]([1-9]|1[0-3]) [SCDH]([1-9]|1[0-3]) [SCDH]([1-9]|1[0-3]) [SCDH]([1-9]|1[0-3])\z/
        errors[:base] << "5つのカード指定文字{半角英字(S,D,C,H)と半角数字(1~13)を組み合わせたもの}を半角スペース区切りで入力してください。(例: S1 H3 D9 C13 S11)"
        cards.each_with_index do |card,idx|
        index = idx +1
          if card !~  /\A[SDCH]([1-9]|1[0-3])\z/
            errors[:base] << "#{index}番目のカードが不正です(#{card})"
          end
        end
      elsif cards.size - cards.uniq.size != 0
        errors[:base] << "カードが重複しています"
      end
    end
  end
end
