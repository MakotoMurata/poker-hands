class HomeController < ApplicationController
  include JudgeModule
  def top
    @hand=HandsJudgeService.new()
  end

  def check
    @hand = HandsJudgeService.new(hand: params[:hands])
    if @hand.judge
      render("/home/show")
    else
      render("/home/error")
    end
  end

  def show
  end

  def error
  end

end
