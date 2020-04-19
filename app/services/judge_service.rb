module JudgeModule
  class HandsJudgeService
      include ActiveModel::Model
      require_relative "hands_service"
      include HandsModule
      attr_accessor :hand
      attr_reader :result
      def judge
        suit = hand.delete("^A-Z| ").split(" ")
        snum = hand.delete("^0-9| ").split(" ")
        num = []
        flush = 0
        straight = 0
        for i in 0..4
            num[i] = snum[i].to_i
        end
        if suit.count(suit[0]) == suit.length
           flush = 1
        end
        if num.sort[1] == num.sort[0] +1 && num.sort[2] == num.sort[0] + 2 && num.sort[3] == num.sort[0] +3 && num.sort[4] == num.sort[0] + 4 || num.sort == [1,10,11,12,13]
            straight = 1
        end
        count_box = []
        for i in 0..num.uniq.length-1
            count_box[i] = num.count(num.uniq[i])
        end

        if count_box.sort.reverse == [4,1]
            @result = YAKU[7]
        elsif  count_box.sort.reverse == [3,2]
            @result = YAKU[6]
        elsif  count_box.sort.reverse == [3,1,1]
            @result = YAKU[3]
        elsif  count_box.sort.reverse == [2,2,1]
            @result = YAKU[2]
        elsif  count_box.sort.reverse == [2,1,1,1]
            @result = YAKU[1]
        elsif count_box.sort.reverse == [1,1,1,1,1]
            if straight == 1 && flush == 1 &&  num.sort != [1,10,11,12,13]
                 @result = YAKU[8]
            elsif flush == 1
                 @result = YAKU[5]
            elsif straight == 1
                 @result = YAKU[4]
            else
                 @result = YAKU[0]
            end
        end
      end

      validate :validate_check
      def validate_check
        cards = hand.split(" ")
        if hand.blank?
          errors[:base] << "5つのカード指定文字を半角スペース区切りで入力してください"
        elsif hand !~ /\A[SDCH]([1-9]|1[0-3]) [SDCH]([1-9]|1[0-3]) [SCDH]([1-9]|1[0-3]) [SCDH]([1-9]|1[0-3]) [SCDH]([1-9]|1[0-3])\z/
          errors[:base] << "5つのカード指定文字を半角スペース区切りで入力してください"
          cards.each_with_index do |card,idx|
            index = idx +1
            if card !~  /\A[SDCH]([1-9]|1[0-3])\z/
               errors[:base] << "#{index}番目のカード指定文字が不正です(#{card})"
            end
          end
        elsif cards.size - cards.uniq.size != 0
          errors[:base] << "カードが重複しています"
        end
      end
  end
end
