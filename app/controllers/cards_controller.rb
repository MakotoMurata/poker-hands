class CardsController < ApplicationController
  require_relative "../services/judge_service"
  include JudgeModule
  def top
  end

  def check
    @card = HandsJudgeService.new(params[:card_set])
    if @card.card_invalid?
      render :error
    else
      @card.judge
      render :result
    end
  end

  def result
  end

  def error
  end
end
