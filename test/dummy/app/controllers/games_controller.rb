class GamesController < ApplicationController
  # GET /games
  def show
    @game = Game.first || Game.create!
    render 'show', layout: false
  end
end
