# frozen_string_literal: true

RSpec.describe WebinarRu::Result do
  describe ".success" do
    subject(:create_result) { described_class.success(value) }

    let(:value) { "Some value" }

    it "returns success result with value", :aggregate_failures do
      result = create_result
      expect(result).to be_success
      expect(result).not_to be_failure
      expect(result.value).to eq value
    end
  end

  describe ".failure" do
    subject(:create_result) { described_class.failure(value) }

    let(:value) { "Some value" }

    it "returns failure result with value", :aggregate_failures do
      result = create_result
      expect(result).to be_failure
      expect(result).not_to be_success
      expect(result.value).to eq value
    end
  end
end
