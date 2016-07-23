# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class EventsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    @game = Game.find(params[:game_id])
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def getState data
    stage_name = data['current_stage']

    state = {
        current_stage: {
            stage_name: stage_name,
            round: 0
          }
      }

    state.merge!(Global8ballGame::BallPosition.config stage_name)

    current_players = {
      current_players: []
    }

    if stage_name == 'PlayForVictory'
      breaker = data['current_breaker']
      state[:balls][0][:owner] = breaker
      current_players[:current_players] << { user_id: breaker}
    end

    if stage_name == 'PlayForBegin'
      state[:balls][0][:owner] = @game.player_1.id
      state[:balls][1][:owner] = @game.player_2.id
      current_players[:current_players] << { user_id: @game.player_1.id}
      current_players[:current_players] << { user_id: @game.player_2.id}
    end

    state.merge!(current_players)

    transmit state.to_json
  end
end
