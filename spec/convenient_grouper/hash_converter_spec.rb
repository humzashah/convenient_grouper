require "spec_helper"

describe ConvenientGrouper::HashConverter do
  let(:column) { :age }
  let(:base_args) do
    {
      column => {
        first: 1,
        second: 2,
        third: 3..5,
        four: %w{one two}
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
      after do
        expect(subject).
          to eq "CASE WHEN (age = 1) THEN 'first' WHEN (age = 2) THEN 'second' WHEN (age BETWEEN 3 AND 5) THEN 'third' WHEN (age IS IN ('one', 'two')) THEN 'four' ELSE '#{default}' END"
      end

      context "with default group" do
        let(:default) { 'def' }
        let(:arg) do
          base_args[column][default] = nil
          base_args
        end
        it {}
      end

      context "without default group" do
        let(:default) { described_class.const_get('DEFAULT_GROUP') }
        let(:arg) { base_args }
        it {}
      end
    end
  end
end
