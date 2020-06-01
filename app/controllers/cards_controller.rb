class CardsController < ApplicationController
  require_relative "../services/judge_service"
  include JudgeModule
  def top
    @hand = HandsJudgeService.new
  end

  def check
    @hand = HandsJudgeService.new(hand: params[:cards])
    if @hand.validate_check
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
