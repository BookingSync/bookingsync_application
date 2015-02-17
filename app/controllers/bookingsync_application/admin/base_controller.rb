require 'jsonapi/resource_controller'

class BookingsyncApplication::Admin::BaseController < JSONAPI::ResourceController
  force_ssl
  respond_to :json

  before_action :set_json_format, :authenticate_account!
  after_action :allow_bookingsync_iframe

  def context
    { current_account: current_account }
  end

  private

    def set_json_format
      if params[:format].blank?
        request.format = :json
      end
    end
end
