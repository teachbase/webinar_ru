# frozen_string_literal: true

RSpec.describe WebinarRu::Api::V3::Client do
  describe "events", :params, :test_connection do
    let(:event_id) { 1233 }

    describe "POST #create /events" do
      subject(:create_event) { client.events.create(params) }

      let(:params) do
        {
          name: event_name,
          access: access_type,
          password: password,
          description: description,
          additional_fields: additional_fields,
          rule: rule,
          is_event_reg_allowed: is_event_reg_allowed,
          starts_at: Time.utc(2020, 12, 1, 9, 30).to_i,
          ends_at: Time.utc(2020, 12, 1, 11).to_i,
          type: webinar_type,
          lang: :ru,
          tags: tags,
          url_alias: url_alias,
          lector_ids: lector_ids,
          duration: 30 * 60, # 30 minutes
          owner_id: owner_id,
          default_reminders_enabled: reminders_enabled,
          image: image_id,
          timezone: "Europe/Moscow"
        }
      end
      let(:expected_request) do
        {
          path: "/v3/events",
          request_method: "POST",
          body: {
            'name' => event_name,
            'access' => access_type.to_s,
            'password' => password,
            'description' => description,
            "additionalFields[][label]" => "Name",
            "additionalFields[][placeholder]" => "val1",
            "additionalFields[][type]" => "text",
            "additionalFields[][values][]" => "var 2",
            'rule' => rule,
            'isEventRegAllowed' => is_event_reg_allowed.to_s,
            "endsAt[date][day]" => "1",
            "endsAt[date][month]" => "12",
            "endsAt[date][year]" => "2020",
            "endsAt[time][hour]" => "14",
            "endsAt[time][minute]" => "0",
            "startsAt[date][day]" => "1",
            "startsAt[date][month]" => "12",
            "startsAt[date][year]" => "2020",
            "startsAt[time][hour]" => "12",
            "startsAt[time][minute]" => "30",
            'type' => webinar_type,
            'lang' => lang,
            'urlAlias' => url_alias,
            'lectorIds[]' => lector_ids.first.to_s,
            'tags[]' => tags.first,
            'ownerId' => owner_id.to_s,
            'defaultRemindersEnabled' => reminders_enabled.to_s,
            'duration' => duration,
            'image' => image_id
          },
          token: token,
          host: host
        }
      end

      it_behaves_like "sends request with body"
      it_behaves_like "returns entity", WebinarRu::Entities::CreateResult

      context "without params" do
        let(:params) do
          {
            name: event_name,
            access: access_type,
            timezone: "Europe/Moscow"
          }
        end
        let(:expected_request) do
          {
            path: "/v3/events",
            request_method: "POST",
            body: {
              'name' => event_name,
              'access' => access_type.to_s
            },
            token: token,
            host: host
          }
        end

        it_behaves_like "sends request with body", WebinarRu::Api::V3::Responses::CreateEvent
      end
    end

    describe "GET #participants /events/{event_id}/participations" do
      subject { client.events(id: event_id).participants(params) }

      let(:response) { File.read("spec/fixtures/participations.json") }
      let(:params) do
        { page: 1, per_page: 100 }
      end
      let(:expected_request) do
        {
          path: "/v3/events/#{event_id}/participations",
          request_method: "GET",
          query: [%w[page 1], %w[perPage 100]],
          token: token,
          host: host
        }
      end

      it_behaves_like "sends request with query"
      it_behaves_like "returns list of entity", WebinarRu::Entities::Participant
    end

    describe "#PUT #moderate /events/{event_id}/moderate" do
      subject { client.events(id: event_id).moderate(params) }

      let(:participants) { %w[some-uniq-id] }
      let(:expected_request) do
        {
          path: "/v3/events/#{event_id}/moderate",
          request_method: "PUT",
          body: {
            'participationIds[]' => "some-uniq-id",
            'isAccepted' => "true"
          },
          token: token,
          host: host
        }
      end
      let(:params) do
        { participants_ids: participants, is_accepted: true }
      end

      it_behaves_like "sends request with body"
    end

    describe "#POST #register /events/{event_id}/register", :user_params do
      subject { client.events(id: event_id).register(params) }

      let(:status) { 201 }

      let(:expected_request) do
        {
          path: "/v3/events/#{event_id}/register",
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
            path: "/v3/events/#{event_id}/register",
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

    describe "POST #invite /events/{event_id}/invite", :user_params do
      subject { client.events(id: event_id).invite(params) }

      let(:users) do
        [
          email: email,
          name: name,
          second_name: second_name,
          additional_fields: additional_fields,
          role: role
        ]
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
          path: "/v3/events/#{event_id}/invite",
          request_method: "POST",
          body: {
            "users[][additionalFields][some-field-id]" => "some user value",
            "users[][email]" => "test@email.test",
            "users[][name]" => "User name",
            "users[][role]" => "LECTURER",
            "users[][secondName]" => "User surname",
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

    describe "POST #create /events/{event_id}/sessions" do
      subject(:create_event) { client.events(id: event_id).sessions.create(params) }

      let(:params) do
        {
          name: event_name,
          access: access_type,
          description: description,
          start_type: start_type,
          starts_at: Time.utc(2020, 12, 1, 9, 30).to_i,
          lang: :ru,
          image: image_id,
          timezone: "Europe/Moscow"
        }
      end
      let(:expected_request) do
        {
          path: "/v3/events/#{event_id}/sessions",
          request_method: "POST",
          body: {
            'name' => event_name,
            'startType' => start_type,
            'access' => access_type.to_s,
            'description' => description,
            "startsAt[date][day]" => "1",
            "startsAt[date][month]" => "12",
            "startsAt[date][year]" => "2020",
            "startsAt[time][hour]" => "12",
            "startsAt[time][minute]" => "30",
            'lang' => lang,
            'image' => image_id
          },
          token: token,
          host: host
        }
      end

      it_behaves_like "sends request with body"
      it_behaves_like "returns entity", WebinarRu::Entities::CreateResult

      context "without params" do
        let(:params) do
          {
            name: event_name,
            access: access_type,
            timezone: "Europe/Moscow"
          }
        end
        let(:expected_request) do
          {
            path: "/v3/events/#{event_id}/sessions",
            request_method: "POST",
            body: {
              'name' => event_name,
              'access' => access_type.to_s
            },
            token: token,
            host: host
          }
        end

        it_behaves_like "sends request with body", WebinarRu::Api::V3::Responses::CreateSession
      end
    end
  end
end
