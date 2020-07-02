# frozen_string_literal: true

RSpec.describe WebinarRu::Api::V3::Client, :test_connection, :params do
  describe "organization" do
    describe "events" do
      let(:event_id) { 'some-uniq-id' }

      describe "GET #show. /organization/events/{event_id}" do
        subject { client.organization.events(id: event_id).show }

        let(:response) { File.read("spec/fixtures/event.json") }
        let(:expected_request) do
          {
            path: "/v3/organization/events/#{event_id}",
            request_method: "GET",
            query: [],
            token: token,
            host: host
          }
        end

        it_behaves_like "sends request with query"
        it_behaves_like "returns entity", WebinarRu::Entities::EventDetail
      end

      describe "PUT #update. /organization/events/{event_id}" do
        subject { client.organization.events(id: event_id).update(params) }

        let(:event_status) { 'STOP' }
        let(:status) { 204 }
        let(:params) do
          {
            name: event_name,
            access: access_type,
            status: event_status,
            password: password,
            description: description,
            lang: :ru,
            starts_at: Time.new(2020, 12, 1, 12, 30).to_i,
            image: image_id,
            url_alias: url_alias,
            duration: 30 * 60, # 30 minutes
            owner_id: owner_id,
            timezone: "Europe/Moscow"
          }
        end
        let(:expected_request) do
          {
            path: "/v3/organization/events/#{event_id}",
            request_method: "PUT",
            body: {
              'name' => event_name,
              'access' => access_type.to_s,
              'status' => event_status,
              'password' => password,
              'description' => description,
              'lang' => lang,
              'urlAlias' => url_alias,
              "startsAt[date][day]" => "1",
              "startsAt[date][month]" => "12",
              "startsAt[date][year]" => "2020",
              "startsAt[time][hour]" => "12",
              "startsAt[time][minute]" => "30",
              'image' => image_id,
              'duration' => duration,
              'ownerId' => owner_id.to_s
            },
            token: token,
            host: host
          }
        end

        it_behaves_like "sends request with body"
      end

      describe 'GET #schedule. /organization/events/schedule' do
        subject { client.organization.events.schedule(params) }

        let(:response) { File.read("spec/fixtures/events.json") }
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
            path: "/v3/organization/events/schedule",
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
              path: "/v3/organization/events/schedule",
              request_method: "GET",
              query: [["from", "2020-12-01T12:45:35"]],
              token: token,
              host: host
            }
          end

          it_behaves_like "sends request with query"
        end
      end

      describe "DELETE #destroy. /organization/events/{event_id}" do
        subject { client.organization.events(id: event_id).destroy }

        let(:status) { 204 }
        let(:expected_request) do
          {
            path: "/v3/organization/events/#{event_id}",
            request_method: "DELETE",
            body: "",
            token: token,
            host: host
          }
        end

        it_behaves_like "sends request"
      end

      describe "PUT #move. /organization/events/{event_id}/move" do
        subject { client.organization.events(id: event_id).move(params) }

        let(:status) { 204 }
        let(:user_id) { 'some-user-uniq-id' }
        let(:params) do
          {
            user_id: user_id
          }
        end
        let(:expected_request) do
          {
            path: "/v3/organization/events/#{event_id}/move",
            request_method: "PUT",
            body: {
              'userId' => user_id
            },
            token: token,
            host: host
          }
        end

        it_behaves_like "sends request with body"
      end
    end
  end
end
