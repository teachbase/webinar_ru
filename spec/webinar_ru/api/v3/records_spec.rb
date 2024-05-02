# frozen_string_literal: true

RSpec.describe WebinarRu::Api::V3::Client, :test_connection do
  describe "records" do
    let(:record_id) { "record-id" }

    describe "GET #index /records" do
      subject { client.records.index(**params) }

      let(:response) { File.read("spec/fixtures/records.json") }
      let(:expected_request) do
        {
          path: "/v3/records",
          request_method: "GET",
          query: [
            ["from", "2020-12-01T12:45:35"],
            ["to", "2020-12-31T12:45:35"],
            %w[id some-uniq-file_id],
            %w[period month],
            %w[userId some-uniq-user_id]
          ],
          token: token,
          host: host
        }
      end
      let(:params) do
        {
          from: Time.new(2020, 12, 0o1, 12, 45, 35).to_i,
          to: Time.new(2020, 12, 31, 12, 45, 35).to_i,
          file_id: "some-uniq-file_id",
          period: "month",
          user_id: "some-uniq-user_id"
        }
      end

      it_behaves_like "sends request with query"
      it_behaves_like "returns list of entity", WebinarRu::Entities::Record
    end

    describe "PUT #update /records/{record_id}" do
      subject { client.records(id: record_id).update(**params) }

      let(:expected_request) do
        {
          path: "/v3/records/#{record_id}",
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

    describe "DELETE #destroy /records/{record_id}" do
      subject { client.records(id: record_id).destroy }

      let(:status) { 204 }
      let(:expected_request) do
        {
          path: "/v3/records/#{record_id}",
          request_method: "DELETE",
          token: token,
          host: host
        }
      end

      it_behaves_like "sends request"
    end

    describe "PUT #share /records/{record_id}/share" do
      subject { client.records(id: record_id).share }

      let(:status) { 204 }
      let(:expected_request) do
        {
          path: "/v3/records/#{record_id}/share",
          request_method: "POST",
          body: { 'isViewable' => "true", 'password' => "qwerty" },
          token: token,
          host: host
        }
      end

      it_behaves_like "sends request"
    end

    describe "conversions" do
      let(:conversion_id) { "conversion_id" }

      describe "POST #create /records/{record_id}/conversions" do
        subject { client.records(id: record_id).conversions.create(**params) }

        let(:response) { File.read("spec/fixtures/convert.json") }
        let(:expected_request) do
          {
            path: "/v3/records/#{record_id}/conversions",
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

      describe "GET #status /records/conversions/{conversion_id}" do
        subject { client.records.conversions(conversion_id: conversion_id).status }

        let(:response) { File.read("spec/fixtures/convert_status.json") }
        let(:expected_request) do
          {
            path: "/v3/records/conversions/#{conversion_id}",
            request_method: "GET",
            token: token,
            host: host
          }
        end

        it_behaves_like "sends request"
        it_behaves_like "returns entity", WebinarRu::Entities::ConversionStatus
      end
    end
  end
end
