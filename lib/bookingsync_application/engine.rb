require "bookingsync"

module BookingsyncApplication
  class Engine < ::Rails::Engine
    isolate_namespace BookingsyncApplication
  end
end

require "bookingsync_application/engine/admin"
