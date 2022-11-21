# frozen_string_literal: true

WebinarRu::Api::V3::Client.scope :event_sessions do
  format :form
  path { "eventsessions" }

  option :id, optional: true

  operation :show do
    http_method :get
    path { id.to_s }

    let(:response_handler) do
      WebinarRu::Api::V3::Responses::Entity.new(
        WebinarRu::Entities::SessionDetail
      )
    end
  end

  operation :update do
    http_method :put
    path { id.to_s }

    option :name,                 optional: true
    option :access, proc(&:to_i), optional: true
    option :description,          optional: true
    option :start_type,           optional: true
    option :starts_at,            optional: true
    option :image,                optional: true
    option :lang, proc(&:upcase), optional: true
    option :additional_fields,    optional: true
    option :duration,             optional: true
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

  operation :participants do
    http_method :get
    path { "#{id}/participations" }

    option :page,     optional: true
    option :per_page, optional: true

    query { safe_options.to_h }
    let(:response_handler) do
      WebinarRu::Api::V3::Responses::EntityList.new(
        WebinarRu::Entities::Participant
      )
    end
  end

  operation :start do
    http_method :put
    path { "#{id}/start" }
  end

  operation :stop do
    http_method :put
    path { "#{id}/stop" }
  end

  operation :register do
    http_method :post
    path { "#{id}/register" }

    option :email
    option :name,              optional: true
    option :second_name,       optional: true
    option :additional_fields, optional: true
    option :nickname,          optional: true
    option :role,              optional: true
    option :is_auto_enter,     optional: true
    option :send_email,        optional: true
    option :avatar,            optional: true
    option :pattr_name,        optional: true
    option :description,       optional: true
    option :organization,      optional: true
    option :position,          optional: true
    option :sex,               optional: true

    body { safe_options }
    let(:response_handler) do
      WebinarRu::Api::V3::Responses::Entity.new(
        WebinarRu::Entities::RegistrationResult
      )
    end
  end

  operation :invite do
    http_method :post
    path { "#{id}/invite" }

    option :users, [] do
      option :email
      option :name,              optional: true
      option :second_name,       optional: true
      option :additional_fields, optional: true
      option :role,              optional: true
    end

    option :is_auto_enter,     optional: true
    option :send_email,        optional: true

    body { safe_options }
    let(:response_handler) do
      WebinarRu::Api::V3::Responses::EntityList.new(
        WebinarRu::Entities::RegistrationResult
      )
    end
  end

  operation :records do
    http_method :put
    path { "#{id}/records" }

    option :is_viewable
    option :password

    body { safe_options }
  end

  scope :conversions do
    operation :create do
      http_method :post
      path { "#{id}/records/conversions" }

      option :quality, optional: true
      option :view,    optional: true

      body { safe_options }
      let(:response_handler) do
        WebinarRu::Api::V3::Responses::Entity.new(
          WebinarRu::Entities::CreateResult
        )
      end
    end
  end
end
