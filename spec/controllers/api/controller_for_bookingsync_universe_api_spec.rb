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

  before_action -> { booingsync_universe_authorize_request! :clients_read, :clients_write }, only: :index

  def index
    head 200
  end

  def other_index
    head 200
  end

  private

  def enable_for_bookingsync_universe_api?
    true
  end
end

RSpec.describe Api::ControllerForBookingsyncUniverseApi, type: :controller do
  before do
    Rails.application.routes.draw do
      namespace :api do
        get "/index" => "controller_for_bookingsync_universe_api#index"
        get "/other_index" => "controller_for_bookingsync_universe_api#other_index"
      end
    end

    request.env["HTTPS"] = "on"
  end

  after do
    Rails.application.reload_routes!
  end

  # Use some meainingful token to rerecord cassettes
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
              get :index

              expect(response).to have_http_status(200)
            end
          end

          context "no scope is permitted" do
            it "returns 403 status", :vcr do
              get :index

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
            get :other_index

            expect(response).to have_http_status(200)
          end
        end
      end

      context "response from BookingSync is not success" do
        before do
          request.headers["Authorization"] = "Bearer invalid"
        end

        it "returns original response from BookingSync", :vcr do
          get :other_index

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
      before do
        allow(controller).to receive(:enable_for_bookingsync_universe_api?).and_return(false)
      end

      it "fallbacks to standard authentication" do
        expect(SentinelForTestingAuthFallback).to receive(:call)

        get :other_index
      end
    end
  end

  context "BookingSync Universe API Access is not enabled" do
    before do
      allow(controller).to receive(:enable_for_bookingsync_universe_api?).and_return(false)
    end

    it "fallbacks to standard authentication" do
      expect(SentinelForTestingAuthFallback).to receive(:call)

      get :other_index
    end
  end
end
