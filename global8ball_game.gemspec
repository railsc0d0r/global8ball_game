$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "global8ball_game/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "global8ball_game"
  s.version     = Global8ballGame::VERSION
  s.authors     = ["Stephan Barth", "Timo Reitz"]
  s.email       = ["railsc0d0r@gmail.com", "godsboss@gmx.de"]
  s.homepage    = "https://p2501.twilightparadox.com"
  s.summary     = "Provides the game for Global8Ball"
  s.description = "Rails-engine to provide the game for Global8Ball. Contains the assets and the scripts including phaser."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 5.0.0.beta3", "< 5.1"
  s.add_dependency "i18n-js", ">= 3.0.0.rc11"
  s.add_dependency "coffee-rails", "~> 4.1.0"

  s.add_development_dependency "konacha"
  s.add_development_dependency "selenium-webdriver"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "rspec-nc"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-rails"
  s.add_development_dependency "pry-remote"
  s.add_development_dependency "pry-nav"
  s.add_development_dependency "byebug"
  s.add_development_dependency "puma"
  s.add_development_dependency "redis"
  s.add_development_dependency "factory_girl"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "headless"
  s.add_development_dependency "uglifier"
end
