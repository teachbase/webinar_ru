# frozen_string_literal: true

WebinarRu::Api::V3::Client.scope :organization do
  format :form
  path { "organization" }

  scope :events do
    path { "events" }

    option :id, optional: true

    operation :show do
      http_method :get
      path { id.to_s }

      let(:response_handler) do
        WebinarRu::Api::V3::Responses::Entity.new(
          WebinarRu::Entities::EventDetail
        )
      end
    end

    operation :update do
      http_method :put
      path { id.to_s }

      option :name,                 optional: true
      option :access, proc(&:to_i), optional: true
      option :status,               optional: true
      option :password,             optional: true
      option :description,          optional: true
      option :lang, proc(&:upcase), optional: true
      option :url_alias,            optional: true
      option :starts_at,            optional: true
      option :image,                optional: true
      option :duration,             optional: true
      option :owner_id,             optional: true
      option :timezone

      let(:converted_params) do
        {
          starts_at: WebinarRu::Utils.to_webinar_time(starts_at, timezone: timezone),
          duration: WebinarRu::Utils.to_ical_duration(duration)
        }.compact
      end

      body { safe_options.merge(converted_params) }
    end

    operation :destroy do
      http_method :delete
      path { id.to_s }
    end

    operation :move do
      http_method :put
      path { "#{id}/move" }

      option :user_id

      body { safe_options }
    end

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
