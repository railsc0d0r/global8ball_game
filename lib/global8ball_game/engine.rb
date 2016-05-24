module Global8ballGame
  class Engine < ::Rails::Engine
    isolate_namespace Global8ballGame

    initializer "global8ball_game.assets.precompile" do |app|
      app.config.assets.precompile += %w( game/*.js global8ball_game/*.js )
    end
  end
end
