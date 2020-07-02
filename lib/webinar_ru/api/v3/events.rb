# frozen_string_literal: true

WebinarRu::Api::V3::Client.scope :events do
  format :form
  option :id, optional: true

  path { "events" }

  operation :create do
    http_method :post

    option :name,   proc(&:to_s)
    option :access, proc(&:to_i)

    option :password,                  optional: true
    option :description,               optional: true
    option :additional_fields,         optional: true
    option :rule,                      optional: true
    option :starts_at,                 optional: true
    option :ends_at,                   optional: true
    option :type,                      optional: true
    option :url_alias,                 optional: true
    option :duration,                  optional: true
    option :owner_id,                  optional: true
    option :tags,                      optional: true
    option :lector_ids,                optional: true
    option :image,                     optional: true
    option :default_reminders_enabled, optional: true
    option :is_event_reg_allowed,      optional: true
    option :lang, proc(&:upcase),      optional: true
    option :timezone

    let(:converted_params) do
      {
        starts_at: WebinarRu::Utils.to_webinar_time(starts_at, timezone: timezone),
        ends_at: WebinarRu::Utils.to_webinar_time(ends_at, timezone: timezone),
        duration: WebinarRu::Utils.to_ical_duration(duration)
      }.compact
    end

    body { safe_options.merge(converted_params) }
    let(:response_handler) { WebinarRu::Api::V3::Responses::CreateEvent.new }
  end

  operation :moderate do
    http_method :put
    path { "#{id}/moderate" }

    option :participants_ids, [], as: :participation_ids
    option :is_accepted

    body { safe_options }
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

  scope :sessions do
    path { "#{id}/sessions" }

    operation :create do
      http_method :post

      option :name,   proc(&:to_s)
      option :access, proc(&:to_i)

      option :description,          optional: true
      option :starts_at,            optional: true
      option :image,                optional: true
      option :lang, proc(&:upcase), optional: true
      option :timezone

      let(:converted_params) do
        { starts_at: WebinarRu::Utils.to_webinar_time(starts_at, timezone: timezone) }.compact
      end

      body { safe_options.merge(converted_params) }
      let(:response_handler) { WebinarRu::Api::V3::Responses::CreateSession.new }
    end
  end
end
