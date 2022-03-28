module BookingsyncApplication
  module Controllers
    module CommonBase
      def self.included(base)
        base.class_eval do
          force_ssl if Rails.version <= "6.0"

          before_action :authenticate_account!
          after_action :allow_bookingsync_iframe
        end
      end
    end
  end
end
