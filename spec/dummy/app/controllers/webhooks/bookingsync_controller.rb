class Webhooks::BookingsyncController < BookingsyncApplication::Webhooks::BaseController
  def everything
    head :ok
  end
end
