# frozen_string_literal: true

module WebinarRu
  module Entities
    # Registration result, returned by invite and register actions
    # option :state [String]
    # - waiting
    # - processing
    # - completed
    # - canceled
    class ConversionStatus
      extend Dry::Initializer

      option :state
    end
  end
end
