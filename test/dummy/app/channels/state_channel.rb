# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class StateChannel < ApplicationCable::Channel
  def subscribed
    stream_from "state_#{params[:game_id]}"
    @game = Game.find(params[:game_id])
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def getState data
    if @game.results.empty?
      stage_name = data['current_stage']
      breaker = data['current_breaker']

      @game.initialize_state stage_name, breaker
    end

    transmit @game.last_result
  end

end
