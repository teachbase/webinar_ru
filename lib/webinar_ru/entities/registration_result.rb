# frozen_string_literal: true

module WebinarRu
  module Entities
    # Registration result, returned by invite and register actions
    #
    # - option `:email` [String] optional property, returned by only #invite
    # - option `:url` [String]
    # - option `:participant_id` [String]
    # - option `:contact_id` [String]
    class RegistrationResult
      extend Dry::Initializer

      option :email, optional: true
      option :link, as: :url, optional: true
      option :participationId, proc(&:to_s), as: :participant_id, optional: true
      option :contactId, proc(&:to_s), as: :contact_id, optional: true
    end
  end
end
