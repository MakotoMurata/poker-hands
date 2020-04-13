class HomeController < ApplicationController

  def top
    @YAKU=[
      "ハイカード",
      "１ペア",
      "２ペア",
      "スリーカード",
      "ストレート",
      "フラッシュ",
      "フルハウス",
      "４カード",
      "ストレートフラッシュ"
    ]
  end

  def check
    #ポーカーの役判定
    #カードをスートと数字に分けて配列に入れる
    @YAKU=[
      "ハイカード",
      "１ペア",
      "２ペア",
      "スリーカード",
      "ストレート",
      "フラッシュ",
      "フルハウス",
      "４カード",
      "ストレートフラッシュ"
    ]
        str = params[:hands] #５枚のカードの内容を、スートと数字をつけて文字列として入力。
        suit = str.delete("^A-Z| ").split(' ')
        snum = str.delete("^0-9| ").split(' ')
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
            puts @YAKU[7]
        elsif  count_box.sort.reverse == [3,2]
            puts @YAKU[6]
        elsif  count_box.sort.reverse == [3,1,1]
            puts @YAKU[3]
        elsif  count_box.sort.reverse == [2,2,1]
            puts @YAKU[2]
        elsif  count_box.sort.reverse == [2,1,1,1]
            puts @YAKU[1]
        elsif count_box.sort.reverse == [1,1,1,1,1]
            if straight == 1 && flush == 1 &&  num.sort != [1,10,11,12,13]
                puts @YAKU[8]
            elsif flush == 1
                puts @YAKU[5]
            elsif straight == 1
                puts @YAKU[4]
            else
                puts @YAKU[0]
            end
        end
           redirect_to("/")
  end

end
