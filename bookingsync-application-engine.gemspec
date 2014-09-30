$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bookingsync_application_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bookingsync-application-engine"
  s.version     = BookingsyncApplicationEngine::VERSION
  s.authors     = ["Marcin Nowicki"]
  s.email       = ["dev@bookingsync.com"]
  s.homepage    = "https://github.com/BookingSync/bookingsync-application-engine"
  s.summary     = "A Rails engine to simplify building BookingSync Applications"
  s.description = "A Rails engine to simplify building BookingSync Applications"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.1.6"

  s.add_development_dependency "pg"
end
