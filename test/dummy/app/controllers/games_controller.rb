class GamesController < ApplicationController
  # GET /games
  def show
    @game = Global8ballGame::Game.all.first

    if @game.nil?
      players = Player.all
      player_1 = players[0]
      player_2 = players[1]

      @game = Global8ballGame::Game.create( player_1_id: player_1.id, player_1_name: player_1.name, player_2_id: player_2.id, player_2_name: player_2.name )
    end

    render 'show', layout: false
  end

  def reset
    @game = Global8ballGame::Game.all.first
    @game.delete unless @game.nil?

    redirect_to root_path
  end
end
