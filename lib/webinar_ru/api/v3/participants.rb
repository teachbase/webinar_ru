# frozen_string_literal: true

WebinarRu::Api::V3::Client.scope :participants do
  format :form
  path { "participations" }

  operation :update do
    http_method :put
    path { "update" }

    option :participants_ids, [], as: :participation_ids
    option :role

    body { safe_options }
  end

  operation :kick do
    http_method :put
    path { "kick" }

    option :participants_ids, [], as: :participation_ids

    body { safe_options }
  end

  operation :delete do
    http_method :post
    path { "delete" }

    option :participants_ids, [], as: :participation_ids

    body { safe_options }
  end
end
