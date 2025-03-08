# frozen_string_literal: true

RSpec.describe WebinarRu::Api::V3::Client, :params, :test_connection do
  describe "users" do
    describe 'GET #schedule. /users/{user_id}/events/schedule' do
      subject { client.users(id: user_id).events.schedule(**params) }

      let(:user_id) { 'uniq-user-id' }

      let(:params) do
        {
          from: Time.new(2020, 12, 0o1, 12, 45, 35).to_i,
          name: event_name,
          status: webinar_status,
          to: Time.new(2020, 12, 31, 12, 45, 35).to_i,
          access: access_type,
          page: 1,
          per_page: 10
        }
      end
      let(:expected_request) do
        {
          path: "/v3/users/#{user_id}/events/schedule",
          request_method: "GET",
          query: [
            ["from", "2020-12-01T12:45:35"],
            ["name", "Event name"],
            ["status[]", "ACTIVE"],
            ["status[]", "START"],
            ["to", "2020-12-31T12:45:35"],
            %w[access 1],
            %w[page 1],
            %w[perPage 10]
          ],
          token: token,
          host: host
        }
      end

      it_behaves_like "sends request with query"
      it_behaves_like "returns list of entity", WebinarRu::Entities::Event

      context "without params" do
        let(:params) do
          {
            from: Time.new(2020, 12, 0o1, 12, 45, 35).to_i
          }
        end
        let(:expected_request) do
          {
            path: "/v3/users/#{user_id}/events/schedule",
            request_method: "GET",
            query: [["from", "2020-12-01T12:45:35"]],
            token: token,
            host: host
          }
        end

        it_behaves_like "sends request with query"
      end
    end
  end
end
