# frozen_string_literal: true

RSpec.describe WebinarRu::Api::V3::Responses::EntityList, :response do
  subject { described_class.new(WebinarRu::Entities::Event).call(raw_data) }
  let(:example_path) { "spec/fixtures/events.json" }

  it "returns array of Event", :aggregate_failures do
    expect(subject.value.first).to have_attributes(
      id: data.first["id"],
      name: data.first["name"],
      estimated_at: data.first["estimatedAt"],
      class: WebinarRu::Entities::Event
    )
    expect(subject.value.first.sessions.first).to have_attributes(
      id: data.first["eventSessions"].first["id"],
      name: data.first["eventSessions"].first["name"],
      class: WebinarRu::Entities::Session
    )
  end
end
