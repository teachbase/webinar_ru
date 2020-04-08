# frozen_string_literal: true

module WebinarRu
  module Entities
    # Session detail entity
    # has options:
    # option :id [String]
    # option :status [String] ACTIVE, STOP, START
    # option :access [Integer]
    # - 1  free access;
    # - 3  free access with a password;
    # - 4  registration;
    # - 6  registration with a password;
    # - 8  registration followed by manual moderation of participants;
    # - 10 registration followed by manual moderation of participants and with a password
    # option :name [String]
    # option :description [String]
    # option :starts_at [String] iso8601 time format
    # option :ends_at [String] iso8601 time format
    # option :create_user_id [String]
    # option :type [String] webinar, meeting
    # option :lang [String] webinar, meeting
    # option :utc_starts_at [Integer] UNIX time
    # option :organization_id [String]
    # option :announce_files [Array<Hash>] information about files added to the event announcement
    # option :additional_fields [Array<Hash>] information about additional registration fields
    # option :files [Array<Hash>] information about files added to the event.
    class SessionDetail < WebinarBase
      option :lang, optional: true
      option :utcStartsAt, optional: true, as: :utc_starts_at
      option :organizationId, proc(&:to_s), optional: true, as: :organization_id
      option :announceFiles, optional: true, as: :announce_files, default: -> { [] }
      option :additionalFields, optional: true, as: :additional_fields, default: -> { [] }
      option :files, optional: true, default: -> { [] }
    end
  end
end
