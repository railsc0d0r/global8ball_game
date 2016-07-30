# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class ShotChannel < ApplicationCable::Channel
  def subscribed
    stream_from "shot_#{params[:game_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def setShot data
    ActionCable.server.broadcast "shot_#{params[:game_id]}", data['shot']
  end
end
