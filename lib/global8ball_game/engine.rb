module Global8ballGame
  class Engine < ::Rails::Engine
    isolate_namespace Global8ballGame

    initializer "global8ball_game.assets.precompile" do |app|
      app.config.assets.precompile += %w( global8ball_game/global8ball_game.js )
    end
  end
end
