require 'rails_helper'
include JudgeModule
include HandsModule
RSpec.describe HandsJudgeService,  type: :service do
  describe 'card_invalid?　メソッド' do
    let(:card){HandsJudgeService.new(card_set)}
    context '判定するカードが空白の場合' do
      let(:card_set){""}
      it '正しいエラーメッセージを表示する' do
        card.card_invalid?
        expect(card.errors).to eq ["5つのカード指定文字{半角英字(S,D,C,H)と半角数字(1~13)を組み合わせたもの}を半角スペース区切りで入力してください。(例: S1 H3 D9 C13 S11)"]
      end
    end
    context '判定するカードが重複している場合' do
      let(:card_set){"S1 S1 S2 S3 S4"}
      it '正しいエラーメッセージを表示する' do
        card.card_invalid?
        expect(card.errors).to eq ["カードが重複しています"]
      end
    end
    context '判定するカードが５枚未満の場合' do
      let(:card_set){"C1"}
      it '正しいエラーメッセージを表示する' do
        card.card_invalid?
        expect(card.errors).to eq ["5つのカード指定文字{半角英字(S,D,C,H)と半角数字(1~13)を組み合わせたもの}を半角スペース区切りで入力してください。(例: S1 H3 D9 C13 S11)"]
      end
    end
    context '判定するカードが６枚以上の場合' do
      let(:card_set){"C7 C6 C5 C4 C3 C2"}
      it '正しいエラーメッセージを表示する' do
        card.card_invalid?
        expect(card.errors).to eq ["5つのカード指定文字{半角英字(S,D,C,H)と半角数字(1~13)を組み合わせたもの}を半角スペース区切りで入力してください。(例: S1 H3 D9 C13 S11)"]
      end
    end
    context '判定するカードにCDSH以外の文字が含まれている場合' do
      let(:card_set){"A7 C6 C5 C4 C3"}
      it '正しいエラーメッセージを表示する' do
        card.card_invalid?
        expect(card.errors).to eq ["5つのカード指定文字{半角英字(S,D,C,H)と半角数字(1~13)を組み合わせたもの}を半角スペース区切りで入力してください。(例: S1 H3 D9 C13 S11)",
                                          "1番目のカードが不正です(A7)"]
      end
    end
    context '判定するカードに1~13以外の文字が含まれている場合' do
      let(:card_set){"C16 C6 C5 C4 C3"}
      it '正しいエラーメッセージを表示する' do
        card.card_invalid?
        expect(card.errors).to eq ["5つのカード指定文字{半角英字(S,D,C,H)と半角数字(1~13)を組み合わせたもの}を半角スペース区切りで入力してください。(例: S1 H3 D9 C13 S11)",
                                          "1番目のカードが不正です(C16)"]
      end
    end
    context '判定するカードが半角スペースで区切られていない場合' do
      let(:card_set){"C2　C3　C4　C5　C6"}
      it '正しいエラーメッセージを表示する' do
        card.card_invalid?
        expect(card.errors).to eq ["5つのカード指定文字{半角英字(S,D,C,H)と半角数字(1~13)を組み合わせたもの}を半角スペース区切りで入力してください。(例: S1 H3 D9 C13 S11)",
                                   "1番目のカードが不正です(C2　C3　C4　C5　C6)"]
      end
    end
  end
  describe 'judge　メソッド' do
    let(:card){HandsJudgeService.new(@card_set)}
    it 'ストレートフラッシュを正しく判定すること' do
      @card_set = "H1 H2 H3 H4 H5"
      card.judge
      expect(card.hand).to eq "ストレートフラッシュ"
    end
    it 'フォーカードを正しく判定すること' do
      @card_set =   "D6 H6 S6 C6 S13"
      card.judge
      expect(card.hand).to eq "フォーカード"
    end
    it 'フルハウスを正しく判定すること' do
      @card_set = "S10 H10 D10 S4 D4"
      card.judge
      expect(card.hand).to eq "フルハウス"
    end
    it 'フラッシュを正しく判定すること' do
      @card_set = "H1 H12 H10 H5 H3"
      card.judge
      expect(card.hand).to eq "フラッシュ"
    end
    it 'ストレートを正しく判定すること' do
      @card_set = "S8 S7 H6 H5 S4"
      card.judge
      expect(card.hand).to eq "ストレート"
    end
    it 'スリーカードを正しく判定すること' do
      @card_set = "S12 C12 D12 S5 C3"
      card.judge
      expect(card.hand).to eq "スリーカード"
    end
    it 'ツーペアを正しく判定すること' do
      @card_set = "H13 D13 C2 D2 H11"
      card.judge
      expect(card.hand).to eq "ツーペア"
    end
    it 'ワンペアを正しく判定すること' do
      @card_set = "C10 S10 S6 H4 H2"
      card.judge
      expect(card.hand).to eq "ワンペア"
    end
    it 'ハイカードを正しく判定すること' do
      @card_set = "D1 D10 S9 C5 C4"
      card.judge
      expect(card.hand).to eq "ハイカード"
    end
  end
end
