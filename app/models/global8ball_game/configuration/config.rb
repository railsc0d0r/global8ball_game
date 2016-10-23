module Global8ballGame
  module Configuration
    class Config
      def config
        @definition
      end

      def config_json
        self.config.to_json
      end
    end
  end
end
