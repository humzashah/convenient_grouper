require "spec_helper"

describe ConvenientGrouper::Error do
  it "is a StandardError" do
    expect(described_class.new).to be_a StandardError
  end
end
