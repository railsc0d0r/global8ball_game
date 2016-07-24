class GamesController < ApplicationController
  # GET /games
  def show
    @game = Game.first || Game.create!
    render 'show', layout: false
  end

  def reset_results
    @game = Game.first || Game.create!
    @game.reset_results

    redirect_to root_path
  end
end
