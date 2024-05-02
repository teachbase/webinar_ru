# frozen_string_literal: true

RSpec.describe WebinarRu::Api::V3::Client, :test_connection do
  describe "stats" do
    describe "GET #events /stats/events" do
      subject { client.stats.events(**params) }

      let(:expected_request) do
        {
          path: "/v3/stats/events",
          request_method: "GET",
          query: [
            ["from", "2020-12-01T12:45:35"],
            ["to", "2020-12-31T12:45:35"],
            %w[userId some-uniq-id],
            %w[eventId some-uniq-id2]
          ],
          token: token,
          host: host
        }
      end

      let(:params) do
        {
          from: Time.new(2020, 12, 0o1, 12, 45, 35).to_i,
          to: Time.new(2020, 12, 31, 12, 45, 35).to_i,
          user_id: "some-uniq-id",
          event_id: "some-uniq-id2"
        }
      end

      it_behaves_like "sends request with query"

      context "without added params" do
        let(:expected_request) do
          {
            path: "/v3/stats/events",
            request_method: "GET",
            query: [
              ["from", "2020-12-01T12:45:35"]
            ],
            token: token,
            host: host
          }
        end

        let(:params) do
          {
            from: Time.new(2020, 12, 0o1, 12, 45, 35).to_i
          }
        end

        it_behaves_like "sends request with query"
      end
    end

    describe "GET #visits" do
      subject { client.stats.visits(**params) }

      let(:expected_request) do
        {
          path: "/v3/stats/users/visits",
          request_method: "GET",
          query: [
            ["from", "2020-12-01T12:45:35"],
            ["to", "2020-12-31T12:45:35"],
            %w[eventId some-uniq-id2],
            %w[email mail_mail@test.test],
            %w[contactId some-uniq-id3]
          ],
          token: token,
          host: host
        }
      end

      let(:params) do
        {
          from: Time.new(2020, 12, 0o1, 12, 45, 35).to_i,
          to: Time.new(2020, 12, 31, 12, 45, 35).to_i,
          event_id: "some-uniq-id2",
          email: "mail_mail@test.test",
          contact_id: "some-uniq-id3"
        }
      end

      it_behaves_like "sends request with query"

      context "without added params" do
        let(:expected_request) do
          {
            path: "/v3/stats/users/visits",
            request_method: "GET",
            query: [
              ["from", "2020-12-01T12:45:35"]
            ],
            token: token,
            host: host
          }
        end

        let(:params) do
          {
            from: Time.new(2020, 12, 0o1, 12, 45, 35).to_i
          }
        end

        it_behaves_like "sends request with query"
      end
    end

    describe "GET #users" do
      subject { client.stats.users(**params) }

      let(:expected_request) do
        {
          path: "/v3/stats/users",
          request_method: "GET",
          query: [
            ["from", "2020-12-01T12:45:35"],
            ["to", "2020-12-31T12:45:35"],
            %w[eventId some-uniq-id2]
          ],
          token: token,
          host: host
        }
      end

      let(:params) do
        {
          from: Time.new(2020, 12, 0o1, 12, 45, 35).to_i,
          to: Time.new(2020, 12, 31, 12, 45, 35).to_i,
          event_id: "some-uniq-id2"
        }
      end

      it_behaves_like "sends request with query"

      context "without added params" do
        let(:expected_request) do
          {
            path: "/v3/stats/users",
            request_method: "GET",
            query: [
              ["from", "2020-12-01T12:45:35"]
            ],
            token: token,
            host: host
          }
        end

        let(:params) do
          {
            from: Time.new(2020, 12, 0o1, 12, 45, 35).to_i
          }
        end

        it_behaves_like "sends request with query"
      end
    end
  end
end
