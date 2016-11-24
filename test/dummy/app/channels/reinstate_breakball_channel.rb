# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class ReinstateBreakballChannel < ApplicationCable::Channel
  def subscribed
    stream_from "reinstate_breakball_#{params[:game_id]}"
    @game = Game.find(params[:game_id])
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def reinstate_breakball data
    reinstate_breakball = data['reinstate_breakball']
  end
end
