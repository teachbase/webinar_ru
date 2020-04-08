# frozen_string_literal: true

require 'rspec'

RSpec.describe WebinarRu::Api::V3::Responses::Base do
  describe "#call" do
    subject { described_class.new.call(data) }

    let(:data) { '{"data": 123}' }

    it "returns result with data", :aggregate_failures do
      expect(subject.value).to eq "data" => 123
      expect(subject).to be_success
    end

    context "with invalid data" do
      let(:data) { 'abracadabra' }

      it "returns result with data", :aggregate_failures do
        expect(subject.value).to include data
        expect(subject).not_to be_success
      end
    end
  end
end
