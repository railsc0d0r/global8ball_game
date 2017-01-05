module Global8ballGame
  class AlarmClock < Ohm::Model
    include Ohm::DataTypes
    include Ohm::Timestamps
    include Wisper::Publisher

    attribute :finish, Type::Time
    reference :game, :Game

    def game
      Game.find game_id
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
  end
end
