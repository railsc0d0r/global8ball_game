# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class ReinstateBreakballChannel < ApplicationCable::Channel
  def subscribed
    stream_from "reinstate_breakball_#{params[:game_id]}"
    @game = Global8ballGame::Game[params[:game_id]]
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def reinstate_breakball data
    breakball_position = data['reinstate_breakball']
    result = @game.eval_reinstating_at breakball_position

    transmit result
    ActionCable.server.broadcast "state_#{params[:game_id]}", (@game.last_result) if result['reinstated']
  end
end
