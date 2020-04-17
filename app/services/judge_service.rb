module JudgeModule
  class HandsJudgeService
      include ActiveModel::Model
      require_relative "hands_service"
      include HandsModule
      attr_accessor :hand
      attr_reader :result
      def judge(hand) #５枚のカードの内容を、スートと数字をつけて文字列として入力。
        suit = hand.delete("^A-Z| ").split(' ')
        snum = hand.delete("^0-9| ").split(' ')
        num = []
        flush = 0
        straight = 0

        for i in 0..4
            num[i] = snum[i].to_i
        end

        #手札のスートが全て一致しているか判定
        if suit.count(suit[0]) == suit.length
           flush = 1
        end

        #手札が全て続き番号（もしくは、[1,10,11,12,13]）になっているか判定
        if num.sort[1] == num.sort[0] +1 && num.sort[2] == num.sort[0] + 2 && num.sort[3] == num.sort[0] +3 && num.sort[4] == num.sort[0] + 4 || num.sort == [1,10,11,12,13]
            straight = 1
        end

        #カードの数を数えてから役を判定
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
  end
end
