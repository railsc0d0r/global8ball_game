$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "global8ball_game/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "global8ball_game"
  s.version     = Global8ballGame::VERSION
  s.authors     = ["stephan"]
  s.email       = ["railsc0d0r@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Global8ballGame."
  s.description = "TODO: Description of Global8ballGame."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 5.0.0.beta3", "< 5.1"
  s.add_dependency "i18n-js", ">= 3.0.0.rc11"
  s.add_dependency "coffee-rails", "~> 4.1.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pry-rails"
end
