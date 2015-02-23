require "rails_helper"

describe Admin::BaseController do
  controller(Admin::BaseController) do
    def index
      render text: "index body"
    end
  end

  let(:account) { create :account }

  before do
    controller.stub(:setup_request)
  end
  before { @request.env['HTTPS'] = 'on' }

  it "redirects to engine authentication path" do
    get :index
    expect(response.body).to include "/auth/bookingsync/?account_id="
  end

  context "when ssl not used" do
    before { @request.env['HTTPS'] = nil }

    it "forces ssl" do
      get :index
      expect(response).to redirect_to 'https://test.host/admin/base'
    end
  end

  context "when X-Frame-Options is set" do
    before do
      allow(controller).to receive(:current_account).and_return(account)
    end

    it "allows to be run in iframe" do
      request.headers['X-Frame-Options'] = 'SAMEORIGIN'
      get :index
      expect(response.headers['X-Frame-Options']).to eq ''
    end
  end

  context "with authenticated account" do
    before do
      allow(controller).to receive(:current_account).and_return(account)
    end

    it "has context set with current_account" do
      expect(controller.context[:current_account]).to eq account
    end
  end

  it "is JSONAPI::ResourceController controller" do
    expect(controller).to be_kind_of JSONAPI::ResourceController
  end
end
