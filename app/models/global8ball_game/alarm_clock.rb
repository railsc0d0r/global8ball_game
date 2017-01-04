module Global8ballGame
  class AlarmClock < Ohm::Model
    include Ohm::DataTypes
    include Ohm::Timestamps

    attribute :finish, Type::Time
    reference :game, :Game

    def game
      Game.find game_id
    end

    def finished?
      !(self.finish > Time.at(Time.now.to_i))
    end

    def add_seconds seconds
      self.finish = self.finish.in seconds
      self.save
    end
  end
end
