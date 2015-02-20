require "bookingsync"
require "synced"
require "dotenv-rails"
require "jsonapi-resources"
require "bookingsync_application/engine"
require 'bookingsync_application/common_base_controller'

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
