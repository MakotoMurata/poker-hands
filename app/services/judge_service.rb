module JudgeModule
  class HandsJudgeService
    include ActiveModel::Model
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

        dupilication = count_box.sort.reverse
      if dupilication == [1,1,1,1,1]
        if straight == 1 && flush == 1 &&  num.sort != [1,10,11,12,13]
          @result = "ストレートフラッシュ"
        elsif flush == 1
          @result = "フラッシュ"
        elsif straight == 1
          @result = "ストレート"
        else
          @result = "ハイカード"
        end
      elsif dupilication == [4,1]
        @result = "フォーカード"
      elsif dupilication == [3,2]
        @result = "フルハウス"
      elsif dupilication == [3,1,1]
        @result = "スリーカード"
      elsif dupilication == [2,2,1]
        @result = "ツーペア"
      elsif dupilication == [2,1,1,1]
        @result = "ワンペア"
      end
    end

    validate :validate_check
    def validate_check
      cards = hand.split(" ")
      if hand.blank?
        errors[:base] <<   "5つのカード指定文字{半角英字(S,D,C,H)と半角数字(1~13)を組み合わせたもの}を半角スペース区切りで入力してください。(例: S1 H3 D9 C13 S11)"
      elsif hand !~ /\A[SDCH]([1-9]|1[0-3]) [SDCH]([1-9]|1[0-3]) [SCDH]([1-9]|1[0-3]) [SCDH]([1-9]|1[0-3]) [SCDH]([1-9]|1[0-3])\z/
        errors[:base] <<   "5つのカード指定文字{半角英字(S,D,C,H)と半角数字(1~13)を組み合わせたもの}を半角スペース区切りで入力してください。(例: S1 H3 D9 C13 S11)"
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
