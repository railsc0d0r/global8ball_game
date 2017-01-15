module Global8ballGame
  class Game < Ohm::Model
    include ModelValidationConcern
    include PhysicsConcern
    include Ohm::DataTypes
    include Ohm::Timestamps
    include Ohm::Callbacks

    attribute :config, Type::Hash
    attribute :player_1_id
    attribute :player_1_name
    attribute :player_2_id
    attribute :player_2_name

    def before_create
      generate_config
    end


    def before_delete
      Result.find(game_id: self.id).map &:delete
    end

    def results
      Result.find(game_id: self.id)
    end

    protected

    def validate
      assert_present(:player_1_id)
      assert_present(:player_1_name)
      assert_present(:player_2_id)
      assert_present(:player_2_name)
    end

    private

    def generate_config
      players_config = {
        player_1: {
          user_id: self.player_1_id,
          name: self.player_1_name
        },
        player_2: {
          user_id: self.player_2_id,
          name: self.player_2_name
        }
      }

      config = self.new_table_config
      config.merge!(players_config)

      self.config = config
    end
  end
end
