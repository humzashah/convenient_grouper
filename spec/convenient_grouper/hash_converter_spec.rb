require "spec_helper"

describe ConvenientGrouper::HashConverter do
  let(:column) { :age }
  let(:group_hash) do
    {
      first: 1,
      third: 2..5,
      four: %w{one two},
      five: "> 6",
      six: ">= 7",
      eight: "< 8",
      nine: "<= 9",
      empty: nil
    }
  end
  let(:default) { nil }
  let(:arg) do
    hash = default ? {nil => default} : {}
    {column => group_hash.merge(hash)}
  end

  let(:restricted) { false }
  let(:instance) { described_class.new(arg, restrict: restricted) }

  describe "initialization" do
    subject { instance }

    describe "proper arguments" do
      after { should be_a described_class }

      context "restricted" do
        let(:restricted) { true }
        it {}
      end

      context "unrestricted" do
        it {}
      end
    end

    describe "improper arguments" do
      after do
        expect{ subject }.
          to raise_error(ConvenientGrouper::Error)
      end

      context "error before create_groups" do
        before do
          expect_any_instance_of(described_class).
            to_not receive(:create_groups)
        end

        context "not a hash" do
          let(:arg) { "non_hash_arg" }
          it {}
        end

        context "improper hash structure" do
          let(:arg) { {age: 10..5} }
          it {}
        end
      end

      context "improper range" do
        let(:arg) { {age: {first: (10..5)}} }

        before do
          expect_any_instance_of(described_class).
            to receive(:create_groups).and_call_original
        end

        it {}
      end
    end
  end

  describe "instance methods" do
    subject { instance.public_send(method) }

    before do
      expect(ConvenientGrouper::Regex).
        to receive(:matches?).
          at_least(:once).
            and_call_original
    end

    after { expect(subject).to eq(expected) }

    describe "groups" do
      let(:method) { :groups }

      let(:expected) do
        "CASE WHEN (age = 1) THEN 'first' WHEN (age BETWEEN 2 AND 5) THEN 'third' WHEN (age IN ('one', 'two')) THEN 'four' WHEN (age > 6) THEN 'five' WHEN (age >= 7) THEN 'six' WHEN (age < 8) THEN 'eight' WHEN (age <= 9) THEN 'nine' WHEN (age IS NULL) THEN 'empty' ELSE '#{default}' END"
      end

      context "with default group" do
        let(:default) { 'def' }
        it("is as expected") {}
      end

      context "without default group" do
        let(:default) { described_class::Default::GROUP }
        it("is as expected") {}
      end
    end

    describe "restrictions" do
      let(:method) { :restrictions }

      context "restricted" do
        let(:restricted) { true }
        let(:expected) do
          "(age = 1) OR (age BETWEEN 2 AND 5) OR (age IN ('one', 'two')) OR (age > 6) OR (age >= 7) OR (age < 8) OR (age <= 9) OR (age IS NULL)"
        end
        it("is as expected") {}
      end

      context "unrestricted" do
        let(:expected) { "" }
        it {}
      end
    end
  end
end
