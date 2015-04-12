require 'spec_helper'

describe ConvenientGrouper do

  describe "gem basics" do
    it 'has a version number' do
      expect(ConvenientGrouper::VERSION).to_not be nil
    end
  end

  describe "effects" do
    let(:arg) { {age: {adults: 18..30}} }
    subject { ActiveRecord::Relation.new(nil, nil).group(arg, options) }

    context "invalid options" do
      let(:options) { {one: 1} }

      it "raises error for improper options" do
        expect{ subject }.to raise_error(ConvenientGrouper::Error)
      end
    end

    context "valid options" do
      let(:options) { {} }
      let(:converter) { described_class::HashConverter }

      before do
        expect(converter).to receive(:new).with(arg, instance_of(Hash)).and_call_original
        expect_any_instance_of(converter).to receive(:groups)
      end

      it("overrides ActiveRecord::Relation's group method") { subject }
    end
  end
end
