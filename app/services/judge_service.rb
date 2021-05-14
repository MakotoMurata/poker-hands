module JudgeModule
  class HandsJudgeService
    include ActiveModel::Model
    require_relative("const/poker_hand_definition")
    include HandsModule
    require_relative('const/error_message_definition')
    include ErrorMessageModule
    attr_accessor :card, :hand, :errors, :hand_power, :valid, :best
    def initialize(card)
      @card = card
      @best = false
    end
    def judge
      suits = card.delete("^A-Z| ").split(" ")
      nums = card.delete("^0-9| ").split(" ").map(&:to_i)
      flush = false
      flush = true if suits.count(suits[0]) == suits.length
      straight = false
      straight = true if nums.sort[1] == nums.sort[0] +1 && nums.sort[2] == nums.sort[0] + 2 && nums.sort[3] == nums.sort[0] +3 && nums.sort[4] == nums.sort[0] + 4 || nums.sort == [1,10,11,12,13]
      count_box = []
      dup_num = nums.uniq
      dup_num.each do |x|
        count_box << nums.count(x)
      end
      duplicate = count_box.sort.reverse
      case [duplicate, straight, flush]
      when [[1,1,1,1,1], true, true]
          @hand = STRAIGHT_FLUSH
          @hand_power = 9
      when [[1,1,1,1,1], true, false]
          @hand = STRAIGHT
          @hand_power = 6
      when [[1,1,1,1,1], false, true]
          @hand = FLUSH
          @hand_power = 6
      when [[1,1,1,1,1], false, false]
          @hand = HIGH_CARD
          @hand_power = 1
      when [[4,1], false, false]
          @hand = FOUR_CARD
          @hand_power = 8
      when [[3,2], false, false]
          @hand = FULL_HOUSE
          @hand_power = 7
      when [[3,1,1], false, false]
          @hand = THREE_CARD
          @hand_power = 4
      when [[2,2,1], false, false]
          @hand = TWO_PAIR
          @hand_power = 3
      when [[2,1,1,1],false, false]
          @hand = ONE_PAIR
          @hand_power = 2
      else
      end
    end

    def valid_check?
      each_card = card.split(" ")
      @errors = []
      if card.empty?
        @errors << FORMAT_ERROR_MSG
        @valid = false
      elsif each_card.size - each_card.uniq.size != 0
        @errors << DUPLICATION_ERROR_MSG
        @valid = false
      elsif card !~ /\A[SDCH]([1-9]|1[0-3]) [SDCH]([1-9]|1[0-3]) [SCDH]([1-9]|1[0-3]) [SCDH]([1-9]|1[0-3]) [SCDH]([1-9]|1[0-3])\z/
        @errors << FORMAT_ERROR_MSG
        each_card.each_with_index do |card,idx|
          index = idx +1
          if card !~  /\A[SDCH]([1-9]|1[0-3])\z/
            @errors << "#{index}番目のカードが不正です(#{card})"
          end
        end
        @valid = false
      else
        @valid = true
      end
    end
  end
end
