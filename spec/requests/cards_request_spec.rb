require 'rails_helper'
 RSpec.describe "V1 API", type: :request do
   def post_request
     post '/api/v1/cards/check', params: cards_set
   end
   describe 'リクエストを正しく受け取る時の処理(status code 201)' do
    let(:cards_set){{"cards": @params}}
    context '全て正しいカード(同じ強さの役がない)の場合' do
      before do
        @params = ["H1 H13 H12 H11 H10", "H9 C9 S9 H2 C2", "C13 D12 C11 H8 H7"]
        post_request
      end
      it 'ステータスコードは201で帰ってくること' do
        expect(response.status).to eq 201
      end
      it '全てのカードが正しく判定されること' do
        json = JSON.parse(response.body)
        expect(json["result"][0]["card"]).to eq "H1 H13 H12 H11 H10"
        expect(json["result"][0]["hand"]).to eq "ストレートフラッシュ"
        expect(json["result"][0]["best"]).to eq true
        expect(json["result"][1]["card"]).to eq "H9 C9 S9 H2 C2"
        expect(json["result"][1]["hand"]).to eq "フルハウス"
        expect(json["result"][1]["best"]).to eq false
        expect(json["result"][2]["card"]).to eq "C13 D12 C11 H8 H7"
        expect(json["result"][2]["hand"]).to eq "ハイカード"
        expect(json["result"][2]["best"]).to eq false
      end
    end
    context '全て正しいカード(同じ強さの役がある)の場合' do
      before do
        @params = [ "H1 H13 H12 H11 H10", "S1 S13 S12 S11 S10", "C13 D12 C11 H8 H7"]
        post_request
      end
      it 'ステータスコードは201で帰ってくること' do
        expect(response.status).to eq 201
      end
      it '全てのカードが正しく判定されること' do
        json = JSON.parse(response.body)
        expect(json["result"][0]["card"]).to eq "H1 H13 H12 H11 H10"
        expect(json["result"][0]["hand"]).to eq "ストレートフラッシュ"
        expect(json["result"][0]["best"]).to eq true
        expect(json["result"][1]["card"]).to eq "S1 S13 S12 S11 S10"
        expect(json["result"][1]["hand"]).to eq "ストレートフラッシュ"
        expect(json["result"][1]["best"]).to eq true
        expect(json["result"][2]["card"]).to eq "C13 D12 C11 H8 H7"
        expect(json["result"][2]["hand"]).to eq "ハイカード"
        expect(json["result"][2]["best"]).to eq false
      end
    end
    context '正しいカードと不正なカードが混ざっている場合' do
        let(:cards_set){{"cards":["H1 H13 H12 H11 H10", "H9 C9 S9 H2 C2",""]}}
      before do
        post_request
      end
      it 'ステータスコードが201で帰ってくること' do
        expect(response.status).to eq 201
      end
      it '正しいカードは正しく判定され、不正なカードはエラーメッセージが表示されること' do
        json = JSON.parse(response.body)
        expect(json["error"][0]["card"]).to eq ""
        expect(json["error"][0]["msg"]).to eq ["5つのカード指定文字{半角英字(S,D,C,H)と半角数字(1~13)を組み合わせたもの}を半角スペース区切りで入力してください。(例: S1 H3 D9 C13 S11)"]
        expect(json["result"][0]["card"]).to eq "H1 H13 H12 H11 H10"
        expect(json["result"][0]["hand"]).to eq "ストレートフラッシュ"
        expect(json["result"][0]["best"]).to eq true
        expect(json["result"][1]["card"]).to eq "H9 C9 S9 H2 C2"
        expect(json["result"][1]["hand"]).to eq "フルハウス"
        expect(json["result"][1]["best"]).to eq false
      end
    end
    context '全て不正なカードである場合' do
      before do
        @params = ["","S1 S1 S2 S3 S4","A1 S2 S3 S4 S5"]
        post_request
      end
      it 'ステータスコードが201で帰ってくること' do
        expect(response.status).to eq 201
      end
      it '全てのカードのエラーメッセージが表示されること' do
        json = JSON.parse(response.body)
        expect(json["error"][0]["card"]).to eq ""
        expect(json["error"][0]["msg"]).to eq ["5つのカード指定文字{半角英字(S,D,C,H)と半角数字(1~13)を組み合わせたもの}を半角スペース区切りで入力してください。(例: S1 H3 D9 C13 S11)"]
        expect(json["error"][1]["card"]).to eq "S1 S1 S2 S3 S4"
        expect(json["error"][1]["msg"]).to eq ["カードが重複しています"]
        expect(json["error"][2]["card"]).to eq "A1 S2 S3 S4 S5"
        expect(json["error"][2]["msg"]).to eq ["5つのカード指定文字{半角英字(S,D,C,H)と半角数字(1~13)を組み合わせたもの}を半角スペース区切りで入力してください。(例: S1 H3 D9 C13 S11)",
                                                "1番目のカードが不正です(A1)"]
      end
    end
  end
  describe 'リクエストのパラメータ形式が間違っている時の処理(status code 400)' do
    let(:cards_set){{"hands": @params}}
    before do
      @params = ["H1 H13 H12 H11 H10", "H9 C9 S9 H2 C2", "C13 D12 C11 H8 H7"]
      post_request
    end
    it 'ステータスコードは400で帰ってくること' do
      expect(response.status).to eq 400
    end
    it 'エラーメッセージが表示されること' do
      json = JSON.parse(response.body)
      expect(json["error"]).to eq "400 Bad request リクエストデータに不正があります"
    end
  end
  describe 'リクエストのurlが間違っていた時の処理(status code 404)' do
    let(:cards_set){{"cards": @params}}
    before do
      @params = [ "H1 H13 H12 H11 H10", "H9 C9 S9 H2 C2", "C13 D12 C11 H8 H7"]
      post '/api/v1/cards/chekk', params: cards_set
    end
    it 'ステータスコードが404で帰ってくること' do
      expect(response.status).to eq 404
    end
    it 'エラーメッセージが表示されること' do
      json = JSON.parse(response.body)
      expect(json["error"]).to eq "404 Not Found リソースがみつかりません"
    end
  end
end
