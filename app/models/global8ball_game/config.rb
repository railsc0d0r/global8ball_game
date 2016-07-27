module Global8ballGame
  class Config
    def config
      @definition
    end

    def config_json
      self.config.to_json
    end
  end
end
