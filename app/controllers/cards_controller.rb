class CardsController < ApplicationController
  require_relative "../services/judge_service"
  include JudgeModule
  def top
    @hand = HandsJudgeService.new
  end

  def check
    @hand = HandsJudgeService.new(hand: params[:cards])
    if @hand.invalid?
      render :error
    else
      @hand.judge
      render :result
    end
  end

  def result
    @hand = HandsJudgeService.new
  end

  def error
    @hand = HandsJudgeService.new
  end
end
