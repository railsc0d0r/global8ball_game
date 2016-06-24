module Global8ballGame
  class Config
    class << self
      def config
        @definition
      end

      def config_json
        self.config.to_json
      end
    end

  end
end
