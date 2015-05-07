module BookingsyncApplication
  module Admin
    module CommonBaseController
      def self.included(base)
        base.class_eval do
          force_ssl

          before_action :authenticate_account!
          after_action :allow_bookingsync_iframe
        end
      end
    end
  end
end
