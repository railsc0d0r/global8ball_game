module Global8ballGame
  class AlarmClock < Ohm::Model
    include ModelValidationConcern
    include Ohm::DataTypes
    include Ohm::Timestamps
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
      assert_present(:game_id)
      assert_present(:finish)
      assert_present(:context)
      assert_present(:player_id)
    end
  end
end
