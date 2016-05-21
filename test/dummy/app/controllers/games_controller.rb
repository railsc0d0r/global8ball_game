class GamesController < ApplicationController
  # GET /games
  def show
    binding.pry
    render 'show', layout: false
  end
end
