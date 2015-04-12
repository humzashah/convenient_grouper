require "spec_helper"

describe ConvenientGrouper::Regex do

  describe "self.matches?" do
    subject { described_class.matches?(arg) }
    after { expect(subject).to eq expectation }

    context "improper argument" do
      let(:expectation) { false }

      context "string" do
        let(:arg) { "! 1" }
        it {}
      end

      context "not a string" do
        let(:arg) { 1 }
        it {}
      end
    end

    context "operators" do
      let(:expectation) { true }

      before do
        expect_any_instance_of(String).
          to receive(:strip).
            at_least(:once).
              and_call_original
      end

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
