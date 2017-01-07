module Global8ballGame
  class AlarmClock < Ohm::Model
    include Ohm::DataTypes
    include Ohm::Timestamps
    include Ohm::Validations
    include Wisper::Publisher

    attribute :finish, Type::Time
    attribute :context, Type::Symbol
    reference :game, :Game
    reference :player, :Player

    def game
      Game.find game_id
    end

    def player
      Player.find player_id
    end

    def finished?
      !(self.finish > Time.at(Time.now.to_i))
    end

    def check!
      broadcast(:sound_the_alarm) if self.finished?
    end

    def add_seconds seconds
      self.finish = self.finish.in seconds
      self.save
    end

    protected

    def validate
      raise "No game given to create AlarmClock." unless assert_present(:game_id)
      raise "No :finish given as timestamp to define when clock runs out." unless assert_present(:finish)
      raise "No :context given for AlarmClock." unless assert_present(:context)
    end
  end
end
