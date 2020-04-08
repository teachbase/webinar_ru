# frozen_string_literal: true

WebinarRu::Api::V3::Client.scope :users do
  format :form
  path { "users" }

  option :id, optional: true

  scope :events do
    path { "#{id}/events" }

    operation :schedule do
      http_method :get
      path { 'schedule' }

      option :from
      option :name,    optional: true
      option :status,  optional: true
      option :to,      optional: true
      option :access,  optional: true
      option :page,    optional: true
      option :per_page, optional: true

      let(:converted_params) do
        {
          status: status&.map(&:upcase),
          from: from && Time.at(from).strftime(WebinarRu::Api::V3::Client::TIME_FORMAT),
          to: to && Time.at(to).strftime(WebinarRu::Api::V3::Client::TIME_FORMAT)
        }.compact
      end

      query { safe_options.merge(converted_params) }
      let(:response_handler) do
        WebinarRu::Api::V3::Responses::EntityList.new(
          WebinarRu::Entities::Event
        )
      end
    end
  end
end
