class AlarmClockNotifier
  attr_reader :result, :alarm_clock_ids

  def initialize
    @result = false
    @alarm_clock_ids = []
  end

  def sound_the_alarm alarm_clock_id
    @result = true
    @alarm_clock_ids << alarm_clock_id
  end
end
