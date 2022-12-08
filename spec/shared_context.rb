# frozen_string_literal: true

RSpec.shared_context "with params", params: true do
  let(:event_name) { "Event name" }
  let(:access_type) { 1 }
  let(:password) { "password" }
  let(:description) { "description" }
  let(:additional_fields) do
    ['label' => "Name", 'type' => "text", 'values' => ["var 1", "var 2"], 'placeholder' => "val1"]
  end
  let(:rule) { "FREQ=DAILY" }
  let(:is_event_reg_allowed) { true }
  let(:start_type) { "autostart" }
  let(:start_at) do
    {
      "date" => { "year" => 2020, "month" => 12, "day" => 1 },
      "time" => { "hour" => 12, "minute" => 30 }
    }
  end
  let(:end_at) do
    {
      "date" => { "year" => 2020, "month" => 12, "day" => 1 },
      "time" => { "hour" => 14, "minute" => 0 }
    }
  end
  let(:webinar_type) { "webinar" }
  let(:url_alias) { "url_alias" }
  let(:lector_ids) { [1] }
  let(:tags) { ["tag"] }
  let(:duration) { "PT0H30M0S" }
  let(:owner_id) { 22 }
  let(:reminders_enabled) { false }
  let(:lang) { "RU" }
  let(:image_id) { 'some-image-id-on-webinar-ru' }
  let(:webinar_status) { %w[ACTIVE START] }
end

RSpec.shared_context "test_connection", test_connection: true do
  let(:status) { 200 }
  let(:connection) { TestConnection.new(status, response) }
  let(:host) { "test" }
  let(:proxy) { nil }
  let(:token) { "test-token" }
  let(:client) { described_class.new(domain: host, token: token, host: nil, proxy: proxy) }
  let(:response) { Hash[].to_json }

  before do
    described_class.connection = connection
  end
end

RSpec.shared_context "user params", user_params: true do
  let(:email) { "test@email.test" }
  let(:name) { "User name" }
  let(:second_name) { "User surname" }
  let(:pattr_name) { "User middle name" }
  let(:additional_fields) do
    { "some-field-id" => "some user value" }
  end
  let(:nickname) { "Poops" }
  let(:role) { "LECTURER" }
  let(:is_auto_enter) { true }
  let(:send_email) { false }
  let(:avatar) { "https://ava.user.test/1.png" }
  let(:description) { "Long text about user" }
  let(:organization) { "Company name" }
  let(:position) { "User company position" }
  let(:sex) { "Man" }
end

RSpec.shared_context "response context", response: true do
  subject { described_class.new.call(raw_data) }

  let(:raw_data) { File.read(example_path) }
  let(:data) { JSON.parse(raw_data) }
  let(:example_path) { "" }
end
