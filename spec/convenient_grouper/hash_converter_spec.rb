require "spec_helper"

describe ConvenientGrouper::HashConverter do
  let(:column) { :age }
  let(:group_hash) do
    {
      first: 1,
      third: 2..5,
      four: %w{one two},
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

  describe "overrides ActiveRecord::Relation's group method" do
    before do
      expect_any_instance_of(described_class).
        to receive(:groups)

      expect(described_class).
        to receive(:new).with(arg).and_call_original
    end

    it "interjects ActiveRecord::Relation 'group'" do
      ActiveRecord::Relation.new(nil, nil).group(arg)
    end
  end

  describe "initialization" do
    subject { instance }

    describe "proper arguments" do
      context "restricted" do
        let(:restricted) { true }
        it { should be_true }
      end

      context "unrestricted" do
        it { should be_true }
      end
    end

    describe "improper arguments" do
      after do
        expect{ subject }.
          to raise_error(ConvenientGrouper::CustomError)
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
    after { expect(subject).to eq(expected) }

    describe "groups" do
      let(:method) { :groups }

      context "with default group" do
        let(:default) { 'def' }
        let(:expected) do
          "CASE WHEN (age = 1) THEN 'first' WHEN (age BETWEEN 2 AND 5) THEN 'third' WHEN (age IN ('one', 'two')) THEN 'four' WHEN (age IS NULL) THEN 'empty' ELSE '#{default}' END"
        end
        it {}
      end

      context "without default group" do
        let(:default) { described_class::DEFAULT_GROUP }
        let(:expected) do
          "CASE WHEN (age = 1) THEN 'first' WHEN (age BETWEEN 2 AND 5) THEN 'third' WHEN (age IN ('one', 'two')) THEN 'four' WHEN (age IS NULL) THEN 'empty' ELSE 'others' END"
        end
        it {}
      end
    end

    describe "restrictions" do
      let(:method) { :restrictions }

      context "restricted" do
        let(:restricted) { true }
        let(:expected) do
          "(age = 1) OR (age BETWEEN 2 AND 5) OR (age IN ('one', 'two')) OR (age IS NULL)"
        end
        it {}
      end

      context "unrestricted" do
        let(:expected) { "" }
        it {}
      end
    end
  end
end
