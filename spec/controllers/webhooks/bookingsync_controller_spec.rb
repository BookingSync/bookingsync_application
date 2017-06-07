require 'rails_helper'

describe Webhooks::BookingsyncController do
  before do
    @request.env['HTTPS'] = 'on'
    ENV["BOOKINGSYNC_APP_SECRET"] = "36ed189dd28fd9576d7745c74fac7d4c1bfa03da37d6e5d7a667b67f6e8d16ed"
  end

  context "old signature match" do
    before { @request.headers["X-Content-Signature"] = "9141f44bfaa6a41812e4e9655ffd02d3c927ac5e" }

    it "responses with status 200" do
      post :everything, "foo"
      expect(response).to be_ok
    end
  end

  context "new signature match" do
    before { @request.headers["X-Content-Signature"] = "2ef33a9deaefe9a6ad0226c8c9db272ca126f10b" }

    it "responses with status 200" do
      post :everything, "foo"
      expect(response).to be_ok
    end
  end

  context "none signature match" do
    before { @request.headers["X-Content-Signature"] = "e42951a4561cf14ffc97def80429542daba31ea6" }

    it "responses with unprocessable_entity status" do
      post :everything, body: "foo"
      expect(response.status).to eq 422
    end
  end
end
