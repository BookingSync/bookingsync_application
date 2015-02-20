require 'jsonapi/resource_controller'

class BookingsyncApplication::Admin::BaseController < JSONAPI::ResourceController
  respond_to :json

  before_action :set_json_format

  include BookingsyncApplication::CommonBaseController

  private

    def set_json_format
      if params[:format].blank?
        request.format = :json
      end
    end
end
