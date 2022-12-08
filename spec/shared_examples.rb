# frozen_string_literal: true

RSpec.shared_examples "returned result with value" do
  it "returns success result" do
    expect(subject).to be_success
  end

  context "with error status" do
    let(:status) { 400 }
    let(:response) { "Error!" }

    it "returns result with data" do
      expect(subject.value).to eq response
    end

    it "returns success result" do
      expect(subject).to be_failure
    end
  end
end

RSpec.shared_examples "returns entity" do |klass|
  it "returns entity #{klass}" do
    expect(subject.value).to be_a(klass)
  end
end

RSpec.shared_examples "returns list of entity" do |klass|
  it "returns list of entity #{klass}" do
    expect(subject.value).to all be_a(klass)
  end
end

RSpec.shared_examples "sends request with body" do
  it_behaves_like "returned result with value"

  it "sends request with params" do
    subject
    expect(connection.path).to eq expected_request[:path]
    expect(connection.request_method).to eq expected_request[:request_method]
    expect(connection.body).to eq expected_request[:body]
    expect(connection.token).to eq expected_request[:token]
    expect(connection.host).to eq "#{expected_request[:host]}.webinar.ru"
    expect(connection.content_type).to eq "application/x-www-form-urlencoded"
  end
end

RSpec.shared_examples "sends request with query" do
  it_behaves_like "returned result with value"

  it "sends request with params", :aggregate_failures do
    subject
    expect(connection.path).to eq expected_request[:path]
    expect(connection.request_method).to eq expected_request[:request_method]
    expect(connection.query).to contain_exactly(*expected_request[:query])
    expect(connection.token).to eq expected_request[:token]
    expect(connection.host).to eq "#{expected_request[:host]}.webinar.ru"
    expect(connection.content_type).to eq "application/x-www-form-urlencoded"
  end
end

RSpec.shared_examples "sends request" do
  it_behaves_like "returned result with value"

  it "sends request with params" do
    subject
    expect(connection.path).to eq expected_request[:path]
    expect(connection.request_method).to eq expected_request[:request_method]
    expect(connection.token).to eq expected_request[:token]
    expect(connection.host).to eq "#{expected_request[:host]}.webinar.ru"
  end
end
