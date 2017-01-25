module Global8ballGame
  module Configuration
    # A parent-class to be inherited by all config-models to provide common functionality
    class Base
      def config
        @definition
      end

      def config_json
        self.config.to_json
      end
    end
  end
end
