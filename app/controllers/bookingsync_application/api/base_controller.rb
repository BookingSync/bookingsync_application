require 'jsonapi/resource_controller'

class BookingsyncApplication::Api::BaseController < JSONAPI::ResourceController
  before_action :set_json_format

  include BookingsyncApplication::Controllers::CommonBase

  protected

  def context
    { current_account: current_account }
  end

  private

  def set_json_format
    request.format = :json if params[:format].blank?
  end
end
