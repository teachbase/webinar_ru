# frozen_string_literal: true

RSpec.describe WebinarRu::Api::V3::Responses::CreateEvent, :response do
  let(:example_path) { "spec/fixtures/create_event.json" }

  it "returns CreateResult" do
    expect(subject.value).to have_attributes id: data["eventId"],
                                             url: data["link"],
                                             class: WebinarRu::Entities::CreateResult
  end
end
