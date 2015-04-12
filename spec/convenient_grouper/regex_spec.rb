require "spec_helper"

describe ConvenientGrouper::Regex do

  describe "matches?" do
    subject { described_class.matcher.call(arg) }

    before do
      expect_any_instance_of(String).
        to receive(:strip).
          at_least(:once).
            and_call_original
    end

    after { expect(subject).to eq expectation }

    context "improper argument " do
      let(:arg) { "! 1" }
      let(:expectation) { false }
      it {}
    end

    context "operators" do
      let(:expectation) { true }

      context "inequality (!=)" do
        let(:arg) { "!= 1" }
        it {}
      end

      context "less than or equal to (<=)" do
        let(:arg) { "<= 1" }
        it {}
      end

      context "less than (<)" do
        let(:arg) { "< 1" }
        it {}
      end

      context "greater than or equal to (>=)" do
        let(:arg) { ">= 1" }
        it {}
      end

      context "greater than (>)" do
        let(:arg) { "> 1" }
        it {}
      end
    end
  end

end
