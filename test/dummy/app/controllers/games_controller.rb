class GamesController < ApplicationController
  # GET /games
  def show
    @game = Game.first || Game.create!
    render 'show', layout: false
  end

  def reset
    @game = Game.first || Game.create!
    @game.destroy

    redirect_to root_path
  end
end
