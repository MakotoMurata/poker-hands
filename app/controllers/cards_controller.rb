class CardsController < ApplicationController
  require_relative "../services/judge_service"
  include JudgeModule
  def top
  end

  def check
    @card = HandsJudgeService.new(params[:card_set])
    if @card.valid_check?
      @card.judge
      render :result
    else
      render :error
    end
  end

  def result
  end

  def error
  end
end
