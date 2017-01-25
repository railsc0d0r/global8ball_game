# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class TimeOutChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "time_out_#{params[:game_id]}"
    @game = Global8ballGame::Game[params[:game_id]]
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
