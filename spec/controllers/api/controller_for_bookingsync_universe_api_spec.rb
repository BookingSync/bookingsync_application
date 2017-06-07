require "rails_helper"

class SentinelForTestingAuthFallback
  def self.call
    raise "should not be called if not stubbed"
  end
end

module FakeAuthOverridableModuleForControllerForBookingsyncUniverseApi
  def authenticate_account!
    SentinelForTestingAuthFallback.call
    super
  end
end

class Api::ControllerForBookingsyncUniverseApi < BookingsyncApplication::Api::BaseController
  include FakeAuthOverridableModuleForControllerForBookingsyncUniverseApi
  include BookingsyncApplication::Controllers::BookingsyncUniverseApiAccess

  before_action -> { bookingsync_universe_authorize_request! :clients_read, :clients_write },
    only: :index_with_authorization

  def index_with_authorization
    head 200
  end

  def index_without_authorization
    head 200
  end
end

RSpec.describe Api::ControllerForBookingsyncUniverseApi, type: :controller do
  before do
    Rails.application.routes.draw do
      namespace :api do
        get "/index_with_authorization" => "controller_for_bookingsync_universe_api#index_with_authorization"
        get "/index_without_authorization" => "controller_for_bookingsync_universe_api#index_without_authorization"
      end
    end

    request.env["HTTPS"] = "on"
  end

  after do
    Rails.application.reload_routes!
  end

  # use some meaningful token to rerecord cassettes
  let(:random_token) { SecureRandom.hex(32) }

  context "BookingSync Universe API Access is enabled" do
    context "token is provided in the request" do
      before do
        request.headers["Authorization"] = "Bearer #{random_token}"
      end

      context "response from BookingSync is success" do
        context "endpoint is guarded by authorization" do
          context "at least one scope is permitted" do
            it "is success", :vcr do
              get :index_with_authorization

              expect(response).to have_http_status(200)
            end
          end

          context "no scope is permitted" do
            it "returns 403 status", :vcr do
              get :index_with_authorization

              expect(response).to have_http_status(403)
              expect(JSON.parse(response.body)).to eq ({
                "errors" => [
                  { "code" => "forbidden" }
                ]
              })
            end
          end
        end

        context "endpoint is not guarded by authorization" do
          it "is success", :vcr do
            get :index_without_authorization

            expect(response).to have_http_status(200)
          end
        end
      end

      context "response from BookingSync is not success" do
        before do
          request.headers["Authorization"] = "Bearer invalid"
        end

        it "returns original response from BookingSync", :vcr do
          get :index_without_authorization

          expect(response).to have_http_status(401)
          expect(JSON.parse(response.body)).to eq ({
            "errors" => [
              { "code" => "unauthorized" }
            ]
          })
        end
      end
    end

    context "token is not provided in the request" do
      it "fallbacks to standard authentication" do
        expect(SentinelForTestingAuthFallback).to receive(:call)

        get :index_without_authorization
      end
    end
  end
end
