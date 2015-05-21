shared_examples_for :synced_model do
  describe '.included_modules' do
    subject { described_class.included_modules }

    it { is_expected.to include Synced::HasSyncedData }
  end
end
