require 'rails_helper'
include JudgeModule
include HandsModule
RSpec.describe HandsJudgeService,  type: :service do
  describe 'HandsJudgeService validate_checkメソッド' do
    it '入力された値が空白の場合にエラーメッセージを表示すること' do
      hand = HandsJudgeService.new(card: "")
      expect(hand.validate_check).to eq ["5つのカード指定文字{半角英字(S,D,C,H)と半角数字(1~13)を組み合わせたもの}を半角スペース区切りで入力してください。(例: S1 H3 D9 C13 S11)"]
    end
    it '入力された値に重複があった場合にエラーメッセージを表示すること' do
      hand = HandsJudgeService.new(card: "S1 S1 S2 S3 S4")
      expect(hand.validate_check).to eq ["カードが重複しています"]
    end
    it '入力された値が５枚未満の時' do
      hand = HandsJudgeService.new(card: "C1")
      expect(hand.validate_check).to eq ["5つのカード指定文字{半角英字(S,D,C,H)と半角数字(1~13)を組み合わせたもの}を半角スペース区切りで入力してください。(例: S1 H3 D9 C13 S11)"]
    end
    it '入力された値が６枚以上の時' do
      hand = HandsJudgeService.new(card: "C7 C6 C5 C4 C3 C2")
      expect(hand.validate_check).to eq ["5つのカード指定文字{半角英字(S,D,C,H)と半角数字(1~13)を組み合わせたもの}を半角スペース区切りで入力してください。(例: S1 H3 D9 C13 S11)"]
    end
    it 'CDSH以外の文字が含まれている時' do
      hand = HandsJudgeService.new(card: "A7 C6 C5 C4 C3")
      expect(hand.validate_check).to eq ["5つのカード指定文字{半角英字(S,D,C,H)と半角数字(1~13)を組み合わせたもの}を半角スペース区切りで入力してください。(例: S1 H3 D9 C13 S11)",
                                        "1番目のカードが不正です(A7)"]
    end
    it '1~13以外の文字が含まれている時' do
      hand= HandsJudgeService.new(card: "A13 C6 C5 C4 C3")
      expect(hand.validate_check).to eq ["5つのカード指定文字{半角英字(S,D,C,H)と半角数字(1~13)を組み合わせたもの}を半角スペース区切りで入力してください。(例: S1 H3 D9 C13 S11)",
                                        "1番目のカードが不正です(A13)"]
    end
    it '半角スペースで区切られていない時' do
      hand = HandsJudgeService.new(card: "C2　C3　C4　C5　C6")
      expect(hand.validate_check).to eq ["5つのカード指定文字{半角英字(S,D,C,H)と半角数字(1~13)を組み合わせたもの}を半角スペース区切りで入力してください。(例: S1 H3 D9 C13 S11)"]
    end
  end

  describe 'judgeメソッド' do
    it 'ストレートフラッシュを正しく判定すること' do
      hand = HandsJudgeService.new(card: "S7 S6 S5 S4 S3")
      expect(hand.judge).to eq "ストレートフラッシュ"
    end
    it 'フォーカードを正しく判定すること' do
      hand = HandsJudgeService.new(card: "D6 H6 S6 C6 S13")
      expect(hand.judge).to eq "フォーカード"
    end
    it 'フルハウスを正しく判定すること' do
      hand = HandsJudgeService.new(card: "S10 H10 D10 S4 D4")
      expect(hand.judge).to eq "フルハウス"
    end
    it 'フラッシュを正しく判定すること' do
      hand = HandsJudgeService.new(card: "H1 H12 H10 H5 H3")
      expect(hand.judge).to eq "フラッシュ"
    end
    it 'ストレートを正しく判定すること' do
      hand = HandsJudgeService.new(card: "S8 S7 H6 H5 S4")
      expect(hand.judge).to eq "ストレート"
    end
    it 'スリーカードを正しく判定すること' do
      hand = HandsJudgeService.new(card: "S12 C12 D12 S5 C3")
      expect(hand.judge).to eq "スリーカード"
    end
    it 'ツーペアを正しく判定すること' do
      hand = HandsJudgeService.new(card: "H13 D13 C2 D2 H11")
      expect(hand.judge).to eq "ツーペア"
    end
    it 'ワンペアを正しく判定すること' do
      hand = HandsJudgeService.new(card: "C10 S10 S6 H4 H2")
      expect(hand.judge).to eq "ワンペア"
    end
    it 'ハイカードを正しく判定すること' do
      hand = HandsJudgeService.new(card: "D1 D10 S9 C5 C4")
      expect(hand.judge).to eq "ハイカード"
    end
  end
end
