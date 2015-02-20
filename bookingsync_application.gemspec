$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bookingsync_application/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bookingsync_application"
  s.version     = BookingsyncApplication::VERSION
  s.authors     = ["Marcin Nowicki", "Mariusz Pietrzyk", "Piotr Marciniak"]
  s.email       = ["dev@bookingsync.com"]
  s.homepage    = "https://github.com/BookingSync/bookingsync_application"
  s.summary     = "A Rails engine to simplify building BookingSync Applications"
  s.description = "A Rails engine to simplify building BookingSync Applications"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", '~> 4.1.0'
  s.add_dependency "bookingsync-engine", '~> 0.4.6'
  s.add_dependency "jsonapi-resources"
  s.add_dependency "rspec-rails"
  s.add_dependency "factory_girl_rails"
  s.add_dependency "synced"
  s.add_dependency "dotenv-rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "vcr"
  s.add_development_dependency "webmock"
end
