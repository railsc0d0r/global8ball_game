#
#  Broadcasts the time_out_event to its corresponding channel if notified
#
class TimeOutChannelNotifier
  def sound_the_alarm alarm_clock_id
    clock = AlarmClock[alarm_clock_id]

    event = {
      context: clock.context,
      player: clock.player_id
    }

    ActionCable.server.broadcast "time_out_#{clock.game_id}", event
  end
end
