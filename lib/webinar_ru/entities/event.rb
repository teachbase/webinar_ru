# frozen_string_literal: true

module WebinarRu
  module Entities
    # Event entity
    #
    # has options:
    #
    # - option `:id` [String]
    # - option `:status` [String] active, stop, start
    # - option `:access` [Integer]
    #     - 1  free access;
    #     - 3  free access with a password;
    #     - 4  registration;
    #     - 6  registration with a password;
    #     - 8  registration followed by manual moderation of participants;
    #     - 10 registration followed by manual moderation of participants and with a password
    # - option `:name` [String]
    # - option `:description` [String]
    # - option `:starts`_at [String] iso8601 time format
    # - option `:ends`_at [String] iso8601 time format
    # - option `:is`_archive [Integer] 1 or 0
    # - option `:create`_user_id [String]
    # - option `:type` [String] webinar, meeting
    # - option `:estimated`_at [String] iso8601 time format
    # - option `:timezone`_name [String] example: "Europe/Moscow"
    # - option `:image` [String] image url
    # - option `:rule` [String] Recurrence Rule, example: "FREQ=DAILY;COUNT=1"
    #   see https://tools.ietf.org/html/rfc5545#section-3.3.10
    # - option `:sessions`, [Array<WebinarRu::Entities::Session>]
    class Event < WebinarBase
      option :isArchive, proc(&:to_i), as: :is_archive, optional: true
      option :estimatedAt, as: :estimated_at, optional: true
      option :timezoneName, as: :timezone_name, optional: true
      option :image, optional: true
      option :rule, optional: true
      option :eventSessions, Array[proc { |v| Session.new(**v) }], as: :sessions, default: -> { [] }
    end
  end
end
