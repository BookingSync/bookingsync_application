require 'jsonapi/resource_controller'

class BookingsyncApplication::Admin::BaseController < JSONAPI::ResourceController
  respond_to :json

  before_action :set_json_format

  include BookingsyncApplication::Admin::CommonBaseController

  private

  def set_json_format
    request.format = :json if params[:format].blank?
  end
end
