# frozen_string_literal: true

RSpec.describe WebinarRu::Api::V3::Client, :test_connection do
  describe "participants" do
    describe "PUT #update. /participations/update" do
      subject { client.participants.update(**params) }

      let(:role) { "ADMIN" }
      let(:participants) { %w[some-uniq-id some-uniq-id2] }
      let(:expected_request) do
        {
          path: "/v3/participations/update", # participations is not mistake! see webinar.ru api doc
          request_method: "PUT",
          body: {
            "participationIds[]" => "some-uniq-id2",
            'role' => role
          },
          token: token,
          host: host
        }
      end
      let(:params) do
        { participants_ids: participants, role: role }
      end

      it_behaves_like "sends request with body"
    end

    describe "PUT #kick /participations/kick" do
      subject { client.participants.kick(**params) }

      let(:role) { "ADMIN" }
      let(:participants) { %w[some-uniq-id some-uniq-id2] }
      let(:expected_request) do
        {
          path: "/v3/participations/kick",
          request_method: "PUT",
          body: {
            "participationIds[]" => "some-uniq-id2"
          },
          token: token,
          host: host
        }
      end
      let(:params) do
        { participants_ids: participants }
      end

      it_behaves_like "sends request with body"
    end

    describe "PUT #delete" do
      subject { client.participants.delete(**params) }

      let(:role) { "ADMIN" }
      let(:participants) { %w[some-uniq-id some-uniq-id2] }
      let(:expected_request) do
        {
          path: "/v3/participations/delete",
          request_method: "POST",
          body: {
            "participationIds[]" => "some-uniq-id2"
          },
          token: token,
          host: host
        }
      end
      let(:params) do
        { participants_ids: participants }
      end

      it_behaves_like "sends request with body"
    end
  end
end
