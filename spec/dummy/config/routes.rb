Rails.application.routes.draw do
  mount BookingSync::Engine => '/'
  namespace :webhooks do
    post "bookingsync/everything", to: "bookingsync#everything"
  end
end
