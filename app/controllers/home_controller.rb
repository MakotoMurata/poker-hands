class HomeController < ApplicationController
  require_relative "../services/judge_service"
  include JudgeModule
  def top
    @hand = HandsJudgeService.new
  end

  def check
    @hand = HandsJudgeService.new
    @hand.judge(params[:hand])
    render :show
  end

  def show
  end

  def error
  end

end
