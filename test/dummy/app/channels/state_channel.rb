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

      state = initialize_state stage_name, breaker
    else
      state = @game.results.last.result_set
    end

    transmit state.to_json
  end

  private

  def initialize_state stage_name, breaker
    state = {
        current_stage: {
            stage_name: stage_name,
            round: 1
          }
      }

    state.merge!(Global8ballGame::BallPosition.config stage_name)

    current_players = {
      current_players: []
    }

    current_results = {
      current_results: []
    }

    if stage_name == 'PlayForBegin'
      state[:balls][0][:owner] = @game.player_1.id
      state[:balls][1][:owner] = @game.player_2.id
      current_players[:current_players] << { user_id: @game.player_1.id}
      current_players[:current_players] << { user_id: @game.player_2.id}
    end

    if stage_name == 'PlayForVictory'
      state[:balls][0][:owner] = breaker
      current_players[:current_players] << { user_id: breaker}
      current_results[:current_results] << {
        stage_name: 'PlayForBegin',
        winner: breaker
      }
    end

    state.merge!(current_players)

    if stage_name == 'ShowResult'
      current_results[:current_results] << {
        stage_name: 'PlayForBegin',
        winner: breaker
      }

      1.upto 3 do |round|
        current_results[:current_results] << {
          stage_name: 'PlayForVictory',
          round: round,
          winner: breaker
        }
      end
    end

    state.merge!(current_results)

    result = new Result
    result.result_set=state

    @game.results << result
    @game.save!

    state
  end
end
