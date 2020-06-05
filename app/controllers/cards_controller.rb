class CardsController < ApplicationController
  require_relative "../services/judge_service"
  include JudgeModule
  def top
    @hand = HandsJudgeService.new
  end

  def check
    @hand = HandsJudgeService.new(card: params[:card_set])
    if @hand.card_invalid?
      render :error
    else
      @hand.judge
      render :result
    end
  end

  def result
  end

  def error
  end
end
