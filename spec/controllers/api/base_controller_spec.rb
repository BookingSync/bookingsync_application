require 'rails_helper'

describe Api::BaseController do
  controller(Api::BaseController) do
    def index
      render plain: "plain text"
    end
  end

  let(:account) { create :account }

  before { @request.env['HTTPS'] = 'on' }

  it 'redirects to engine authentication path' do
    get :index, format: :html

    expect(response.body).to include '/auth/bookingsync'
  end

  if Rails.version < "6.1"
    context 'when ssl not used' do
      before { @request.env['HTTPS'] = nil }

      it 'forces ssl' do
        get :index
        expect(response).to redirect_to 'https://test.host/api/base'
      end
    end
  end

  context 'when X-Frame-Options is set' do
    before do
      allow(controller).to receive(:current_account).and_return(account)
    end

    it 'allows to be run in iframe' do
      request.headers['X-Frame-Options'] = 'SAMEORIGIN'
      get :index
      expect(response.headers['X-Frame-Options']).to eq ''
    end
  end

  context 'with authenticated account' do
    before do
      allow(controller).to receive(:current_account).and_return(account)
    end

    it 'has context set with current_account' do
      expect(controller.send(:context)).to eq(current_account: account)
    end
  end

  it 'is JSONAPI::ResourceController controller' do
    expect(controller).to be_kind_of JSONAPI::ResourceController
  end
end
