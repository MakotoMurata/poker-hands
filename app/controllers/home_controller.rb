class HomeController < ApplicationController
  require_relative "../services/judge_service"
  include JudgeModule
  def top
    @hand = HandsJudgeService.new
  end

  def check
    @hand = HandsJudgeService.new(hand: params[:hand])
    if @hand.invalid?
      render :error
    elsif
      @hand.judge
      render :show
    end
  end

  def show
    @hand = HandsJudgeService.new
  end

  def error
    @hand = HandsJudgeService.new
  end

end
