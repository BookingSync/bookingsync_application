shared_examples_for :synced_model do
  describe '.included_modules' do
    subject { described_class.included_modules }

    it { is_expected.to include Synced::HasSyncedData }
  end
end

require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.filter_sensitive_data('Bearer <OAUTH_TOKEN>') do |interaction|
    if interaction.request.headers['Authorization']
      interaction.request.headers['Authorization'].first
    end
  end
  config.ignore_hosts 'codeclimate.com'
end
