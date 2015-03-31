require "spec_helper"

describe ConvenientGrouper::HashConverter do
  let(:column) { :age }
  let(:base_args) do
    {
      column => {
        first: 1,
        third: 2..5,
        four: %w{one two},
        empty: nil
      }
    }
  end

  describe "involvement with ActiveRecord::Relation 'group'" do
    before do
      expect_any_instance_of(described_class).
        to receive(:grouper)

      expect(described_class).
        to receive(:new).with(base_args).and_call_original
    end

    it "interjects ActiveRecord::Relation 'group'" do
      ActiveRecord::Relation.new(nil, nil).group(base_args)
    end
  end

  describe "grouper" do
    subject { described_class.new(arg).grouper }

    describe "failure" do
      after do
        expect{ subject }.
          to raise_error(ConvenientGrouper::CustomError)
      end

      describe "improper argument" do
        context "error before creating grouper" do
          before do
            expect_any_instance_of(described_class).
              to_not receive(:create_grouper)
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
              to receive(:create_grouper).and_call_original
          end

          it {}
        end
      end
    end

    describe "success" do
      after { expect(subject).to eq(expected) }

      context "with default group" do
        let(:default) { 'def' }
        let(:arg) do
          base_args[column][nil] = default
          puts base_args
          base_args
        end
        let(:expected) do
          "CASE WHEN (age = 1) THEN 'first' WHEN (age BETWEEN 2 AND 5) THEN 'third' WHEN (age IN ('one', 'two')) THEN 'four' WHEN (age IS NULL) THEN 'empty' ELSE 'def' END"
        end
        it {}
      end

      context "without default group" do
        let(:default) { described_class.const_get('DEFAULT_GROUP') }
        let(:arg) { base_args }
        let(:expected) do
          "CASE WHEN (age = 1) THEN 'first' WHEN (age BETWEEN 2 AND 5) THEN 'third' WHEN (age IN ('one', 'two')) THEN 'four' WHEN (age IS NULL) THEN 'empty' ELSE 'others' END"
        end
        it {}
      end
    end
  end
end
