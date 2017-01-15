# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class ShotChannel < ApplicationCable::Channel
  def subscribed
    stream_from "shot_#{params[:game_id]}"
    @game = Global8ballGame::Game[params[:game_id]]
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def setShot data
    shot = data['shot']

    ActionCable.server.broadcast "shot_#{params[:game_id]}", { shot: shot }
    ActionCable.server.broadcast "state_#{params[:game_id]}", (@game.eval_shot shot)
  end
end
