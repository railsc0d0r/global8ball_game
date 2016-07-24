# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class StateChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
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

    state = @game.results.last.result_set

    transmit state.to_json
  end

end
