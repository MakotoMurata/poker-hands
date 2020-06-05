module JudgeModule
  class HandsJudgeService
    include ActiveModel::Model

    require_relative("const/poker_hand_definition")
    include HandsModule

    attr_accessor :card, :hand, :errors, :power, :invalid

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
          @hand = STRAIGHT_FLUSH
          @power = 8
      when [[1,1,1,1,1], true, false]
          @hand = STRAIGHT
          @power = 5
      when [[1,1,1,1,1], false, true]
          @hand = FLUSH
          @power = 5
      when [[1,1,1,1,1], false, false]
          @hand = HIGH_CARD
          @power = 0
      when [[4,1], false, false]
          @hand = FOUR_CARD
          @power = 7
      when [[3,2], false, false]
          @hand = FULL_HOUSE
          @power = 6
      when [[3,1,1], false, false]
          @hand = THREE_CARD
          @power = 3
      when [[2,2,1], false, false]
          @hand = TWO_PAIR
          @power = 2
      when [[2,1,1,1],false, false]
          @hand = ONE_PAIR
          @power = 1
      else
      end
    end

    def card_invalid?
      each_card = card.split(" ")
      @errors = []
      @invalid = false
      if each_card.empty?
        @errors << "5つのカード指定文字{半角英字(S,D,C,H)と半角数字(1~13)を組み合わせたもの}を半角スペース区切りで入力してください。(例: S1 H3 D9 C13 S11)"
        @invalid = true
      elsif each_card.size - each_card.uniq.size != 0
        @errors << "カードが重複しています"
        @invalid = true
      elsif card !~ /\A[SDCH]([1-9]|1[0-3]) [SDCH]([1-9]|1[0-3]) [SCDH]([1-9]|1[0-3]) [SCDH]([1-9]|1[0-3]) [SCDH]([1-9]|1[0-3])\z/
        @errors << "5つのカード指定文字{半角英字(S,D,C,H)と半角数字(1~13)を組み合わせたもの}を半角スペース区切りで入力してください。(例: S1 H3 D9 C13 S11)"
        @invalid = true
        each_card.each_with_index do |card,idx|
          index = idx +1
          if card !~  /\A[SDCH]([1-9]|1[0-3])\z/
            @errors << "#{index}番目のカードが不正です(#{card})"
          end
        end
      end
    end
  end
end
