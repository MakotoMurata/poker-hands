require 'rails_helper'
RSpec.describe CardsController, type: :controller do
  describe 'Get #top' do
    before do
      get :top
    end
    it 'リクエストは200 OKとなること' do
      expect(response.status).to eq 200
    end
    it 'topテンプレートを表示すること' do
      expect(response).to render_template :top
    end
  end

  describe 'Post #check' do
    let(:hand) {HandsJudgeService.new(card: params[:card_set])}
    context '入力された値に不正がある場合' do
      before do
        hand = ""
        post :check, params: {card_set: hand}
      end
      it 'errorテンプレートを表示すること' do
        expect(response).to render_template :error
      end
    end
    context '入力された値に不正がない場合' do
      before do
        hand = "S1 S2 S3 S4 S5"
        post :check, params: {card_set: hand}
      end
      it 'resultテンプレートを表示すること' do
        expect(response).to render_template :result
      end
    end
  end

  describe 'Get #result' do
    before do
        get :result
    end
    it 'リクエストは200 OKとなること' do
      expect(response.status).to eq 200
    end
    it 'resultテンプレートを表示すること' do
      expect(response).to render_template :result
    end
  end

  describe 'Get #error' do
    before do
      get :error
    end
    it 'リクエストは200 OKとなること' do
      expect(response.status).to eq 200
    end
    it 'errorテンプレートを表示すること' do
      expect(response).to render_template :error
    end
  end
end
