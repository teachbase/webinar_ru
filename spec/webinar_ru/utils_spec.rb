# frozen_string_literal: true

RSpec.describe WebinarRu::Utils do
  describe ".to_ical_duration" do
    subject { described_class.to_ical_duration(time) }

    let(:time) { 5430 }

    it "converts to ical format string" do
      expect(subject).to eq "PT1H30M30S"
    end
  end

  describe ".to_webinar_time" do
    subject { described_class.to_webinar_time(time, timezone: "Europe/Moscow") }

    let(:time) { Time.new(2020, 12, 1, 12, 30).to_i }

    it "converts to ical format string" do
      expect(subject).to eq(
        date: { year: 2020, month: 12, day: 1 },
        time: { hour: 12, minute: 30 }
      )
    end
  end

  describe ".camelize" do
    subject { described_class.camelize("something_like_this") }

    it "camelize world" do
      expect(subject).to eq "somethingLikeThis"
    end
  end

  describe ".camelize_keys" do
    subject do
      described_class.camelize_keys(
        foo_bar: 'val', baz: { main_params: "val", params: 'val' }, params: [user_id: 1]
      )
    end

    it "camelize hash" do
      expect(subject).to eq "fooBar" => 'val',
                            "baz" => { "mainParams" => "val", "params" => 'val' },
                            "params" => ["userId" => 1]
    end
  end

  describe ".symbolize_keys" do
    subject do
      described_class.symbolize_keys(
        "fooBar" => 'val',
        "baz" => { "mainParams" => "val", "params" => 'val' },
        "params" => ["userId" => 1]
      )
    end

    it "symbolize hash keys" do
      expect(subject).to eq fooBar: 'val',
                            baz: { mainParams: "val", params: 'val' }, params: [userId: 1]
    end
  end
end
