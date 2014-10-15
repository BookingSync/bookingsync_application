$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bookingsync_application/engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bookingsync-application-engine"
  s.version     = BookingsyncApplication::ENGINE_VERSION
  s.authors     = ["Marcin Nowicki", "Mariusz Pietrzyk"]
  s.email       = ["dev@bookingsync.com"]
  s.homepage    = "https://github.com/BookingSync/bookingsync-application-engine"
  s.summary     = "A Rails engine to simplify building BookingSync Applications"
  s.description = "A Rails engine to simplify building BookingSync Applications"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.1.6"
  s.add_dependency "jsonapi-resources", "~> 0.0.5"
  s.add_dependency "bookingsync-engine", "~> 0.1.0"
  s.add_dependency "guard-livereload"
  s.add_dependency "guard-rspec"
  s.add_dependency "rspec-rails"
  s.add_dependency "factory_girl_rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pg"
end
