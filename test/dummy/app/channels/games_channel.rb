# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class GamesChannel < ApplicationCable::Channel
  def subscribed
    @game = Game.find(params[:game_id])
    transmit @game.config
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
