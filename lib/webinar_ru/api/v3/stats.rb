# frozen_string_literal: true

WebinarRu::Api::V3::Client.scope :stats do
  format :form
  path { "stats" }

  let(:converted_params) do
    {
      from: from && Time.at(from).strftime(WebinarRu::Api::V3::Client::TIME_FORMAT),
      to: to && Time.at(to).strftime(WebinarRu::Api::V3::Client::TIME_FORMAT)
    }.compact
  end

  operation :visits do
    http_method :get
    path { 'users/visits' }

    option :from
    option :to,         optional: true
    option :event_id,   optional: true
    option :email,      optional: true
    option :contact_id, optional: true

    query { safe_options.merge(converted_params) }
  end

  operation :users do
    http_method :get
    path { 'users' }

    option :from
    option :to,       optional: true
    option :event_id, optional: true

    query { safe_options.merge(converted_params) }
  end

  operation :events do
    http_method :get
    path { 'events' }

    option :from
    option :to,       optional: true
    option :user_id,  optional: true
    option :event_id, optional: true

    query { safe_options.merge(converted_params) }
  end
end
