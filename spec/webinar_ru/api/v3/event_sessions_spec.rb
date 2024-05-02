# frozen_string_literal: true

RSpec.describe WebinarRu::Api::V3::Client, :test_connection, :params do
  describe "eventsessions" do
    let(:event_session_id) { 'some-uniq-id' }

    describe "GET #show. /eventsessions/{event_session_id}" do
      subject { client.event_sessions(id: event_session_id).show }

      let(:response) { File.read("spec/fixtures/session.json") }
      let(:expected_request) do
        {
          path: "/v3/eventsessions/#{event_session_id}",
          request_method: "GET",
          query: [],
          token: token,
          host: host
        }
      end

      it_behaves_like "sends request with query"
      it_behaves_like "returns entity", WebinarRu::Entities::SessionDetail
    end

    describe "PUT #update /eventsessions/{event_session_id}" do
      subject { client.event_sessions(id: event_session_id).update(**params) }

      let(:status) { 204 }
      let(:params) do
        {
          name: event_name,
          access: access_type,
          description: description,
          additional_fields: additional_fields,
          start_type: start_type,
          starts_at: Time.utc(2020, 12, 1, 9, 30).to_i,
          lang: :ru,
          image: image_id,
          duration: 1800,
          timezone: "Europe/Moscow"
        }
      end
      let(:expected_request) do
        {
          path: "/v3/eventsessions/#{event_session_id}",
          request_method: "PUT",
          body: {
            'name' => event_name,
            'startType' => start_type,
            'access' => access_type.to_s,
            'description' => description,
            'lang' => lang,
            "startsAt[date][day]" => "1",
            "startsAt[date][month]" => "12",
            "startsAt[date][year]" => "2020",
            "startsAt[time][hour]" => "12",
            "startsAt[time][minute]" => "30",
            'image' => image_id.to_s,
            "additionalFields[][label]" => "Name",
            "additionalFields[][placeholder]" => "val1",
            "additionalFields[][type]" => "text",
            "additionalFields[][values][]" => "var 2",
            "duration" => "PT0H30M0S"
          },
          token: token,
          host: host
        }
      end

      it_behaves_like "sends request with body"
    end

    describe "GET #participants /eventsessions/{event_session_id}/participations" do
      subject { client.event_sessions(id: event_session_id).participants(**params) }

      let(:response) { File.read("spec/fixtures/participations.json") }
      let(:params) do
        { page: 1, per_page: 100 }
      end
      let(:expected_request) do
        {
          path: "/v3/eventsessions/#{event_session_id}/participations",
          request_method: "GET",
          query: [%w[page 1], %w[perPage 100]],
          token: token,
          host: host
        }
      end

      it_behaves_like "sends request with query"
      it_behaves_like "returns list of entity", WebinarRu::Entities::Participant
    end

    describe "PUT #records /eventsessions/{event_session_id}/records" do
      subject { client.event_sessions(id: event_session_id).records(**params) }

      let(:expected_request) do
        {
          path: "/v3/eventsessions/#{event_session_id}/records",
          request_method: "PUT",
          body: { 'isViewable' => "true", 'password' => "qwerty" },
          token: token,
          host: host
        }
      end
      let(:params) do
        { is_viewable: true, password: "qwerty" }
      end

      it_behaves_like "sends request with body"
    end

    describe "POST #conversions /eventsessions/{event_session_id}/records/conversions" do
      subject { client.event_sessions(id: event_session_id).conversions.create(**params) }

      let(:response) { File.read("spec/fixtures/convert.json") }
      let(:expected_request) do
        {
          path: "/v3/eventsessions/#{event_session_id}/records/conversions",
          request_method: "POST",
          body: { 'quality' => "720", 'view' => "questions" },
          token: token,
          host: host
        }
      end
      let(:params) do
        { quality: 720, view: :questions }
      end

      it_behaves_like "sends request with body"
      it_behaves_like "returns entity", WebinarRu::Entities::CreateResult
    end

    describe "PUT #start. /eventsessions/{event_session_id}/start" do
      subject { client.event_sessions(id: event_session_id).start }

      let(:status) { 204 }
      let(:expected_request) do
        {
          path: "/v3/eventsessions/#{event_session_id}/start",
          request_method: "PUT",
          body: "",
          token: token,
          host: host
        }
      end

      it_behaves_like "sends request"
    end

    describe "PUT #stop. /eventsessions/{event_session_id}/stop" do
      subject { client.event_sessions(id: event_session_id).stop }

      let(:status) { 204 }
      let(:expected_request) do
        {
          path: "/v3/eventsessions/#{event_session_id}/stop",
          request_method: "PUT",
          body: "",
          token: token,
          host: host
        }
      end

      it_behaves_like "sends request"
    end

    describe "DELETE #destroy. /eventsessions/{event_session_id}" do
      subject { client.event_sessions(id: event_session_id).destroy }

      let(:status) { 204 }
      let(:expected_request) do
        {
          path: "/v3/eventsessions/#{event_session_id}",
          request_method: "DELETE",
          body: "",
          token: token,
          host: host
        }
      end

      it_behaves_like "sends request"
    end

    describe "POST #register /eventsessions/{event_session_id}/register", :user_params do
      subject { client.event_sessions(id: event_session_id).register(**params) }

      let(:response) { File.read("spec/fixtures/register.json") }
      let(:params) do
        {
          email: email,
          name: name,
          second_name: second_name,
          additional_fields: additional_fields,
          nickname: nickname,
          role: role,
          is_auto_enter: is_auto_enter,
          send_email: send_email,
          avatar: avatar,
          pattr_name: pattr_name,
          description: description,
          organization: organization,
          position: position,
          sex: sex
        }
      end
      let(:expected_request) do
        {
          path: "/v3/eventsessions/#{event_session_id}/register",
          request_method: "POST",
          body: {
            'email' => email,
            'name' => name,
            'secondName' => second_name,
            'additionalFields[some-field-id]' => additional_fields["some-field-id"],
            'nickname' => nickname,
            'role' => role,
            'isAutoEnter' => is_auto_enter.to_s,
            'sendEmail' => send_email.to_s,
            'avatar' => avatar,
            'pattrName' => pattr_name,
            'description' => description,
            'organization' => organization,
            'position' => position,
            'sex' => sex
          },
          token: token,
          host: host
        }
      end

      it_behaves_like "sends request with body"
      it_behaves_like "returns entity", WebinarRu::Entities::RegistrationResult

      context "without params" do
        let(:params) do
          {
            email: email
          }
        end
        let(:expected_request) do
          {
            path: "/v3/eventsessions/#{event_session_id}/register",
            request_method: "POST",
            body: {
              'email' => email
            },
            token: token,
            host: host
          }
        end

        it_behaves_like "sends request with body"
      end
    end

    describe "POST #invite. /eventsessions/{event_session_id}/invite", :user_params do
      subject { client.event_sessions(id: event_session_id).invite(**params) }

      let(:response) { File.read("spec/fixtures/invite.json") }
      let(:users) do
        {
          0 => {
            email: email,
            name: name,
            second_name: second_name,
            additional_fields: additional_fields,
            role: role
          },
          1 => {
            email: "admin@tb.com",
            role: "ADMIN"
          }
        }
      end
      let(:params) do
        {
          users: users,
          is_auto_enter: is_auto_enter,
          send_email: send_email
        }
      end
      let(:expected_request) do
        {
          path: "/v3/eventsessions/#{event_session_id}/invite",
          request_method: "POST",
          body: {
            "users[0][additionalFields][some-field-id]" => additional_fields["some-field-id"],
            "users[0][email]" => "test@email.test",
            "users[0][name]" => "User name",
            "users[0][role]" => "LECTURER",
            "users[0][secondName]" => "User surname",
            "users[1][email]" => "admin@tb.com",
            "users[1][role]" => "ADMIN",
            'isAutoEnter' => is_auto_enter.to_s,
            'sendEmail' => send_email.to_s
          },
          token: token,
          host: host
        }
      end

      it_behaves_like "sends request with body"
      it_behaves_like "returns list of entity", WebinarRu::Entities::RegistrationResult
    end
  end
end
