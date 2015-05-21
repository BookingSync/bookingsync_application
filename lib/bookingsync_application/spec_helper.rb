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
  config.filter_sensitive_data('BOOKINGSYNC_OAUTH_ACCESS_TOKEN') do
    ENV['BOOKINGSYNC_OAUTH_ACCESS_TOKEN']
  end
  config.ignore_hosts 'codeclimate.com'
end
