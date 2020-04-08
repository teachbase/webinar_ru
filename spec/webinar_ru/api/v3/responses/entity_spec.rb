# frozen_string_literal: true

RSpec.describe WebinarRu::Api::V3::Responses::Entity, :response do
  subject { described_class.new(WebinarRu::Entities::SessionDetail).call(raw_data) }
  let(:example_path) { "spec/fixtures/session.json" }

  it "returns array of Event", :aggregate_failures do
    expect(subject.value).to have_attributes(
      id: data["id"].to_s,
      name: data["name"],
      class: WebinarRu::Entities::SessionDetail
    )
  end
end
