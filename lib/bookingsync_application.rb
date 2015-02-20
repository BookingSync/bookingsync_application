require "bookingsync"
require "synced"
require "dotenv"
require "jsonapi-resources"
require "bookingsync_application/engine"

module BookingsyncApplication
  mattr_accessor :master_controller_class

  def self.master_controller_class
    if @@master_controller_class
      @@master_controller_class.constantize
    else
      ApplicationController
    end
  end
end
