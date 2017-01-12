$:.push File.expand_path("../lib", __FILE__)
require 'rails_com/version'

Gem::Specification.new do |s|
  s.name        = "rails_com"
  s.version     = RailsCom::VERSION
  s.authors     = ["qinmingyuan"]
  s.email       = ["mingyuan0715@foxmail.com"]
  s.homepage    = 'https://github.com/qinmingyuan/rails_com'
  s.summary     = "Summary of RailsCom."
  s.description = "Description of RailsCom."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.1"

  s.add_development_dependency "sqlite3"
end
