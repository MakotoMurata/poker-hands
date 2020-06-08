class CardsController < ApplicationController
  require_relative "../services/judge_service"
  include JudgeModule
  def top
  end

  def check
    @card = HandsJudgeService.new(params[:card_set])
    @card.valid_check
    if @card.errors.empty?
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
