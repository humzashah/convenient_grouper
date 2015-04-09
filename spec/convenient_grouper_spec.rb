require 'spec_helper'

describe ConvenientGrouper do
  describe "gem basics" do
    it 'has a version number' do
      expect(ConvenientGrouper::VERSION).not_to be nil
    end
  end

  describe "effects" do
    let(:arg) { {age: {adults: 18..30}} }
    let(:converter) { described_class::HashConverter }

    it "overrides ActiveRecord::Relation's group method" do
      expect(converter).
        to receive(:new).with(arg, instance_of(Hash)).and_call_original
      expect_any_instance_of(converter).to receive(:groups)

      ActiveRecord::Relation.new(nil, nil).group(arg)
    end
  end
end
