# frozen_string_literal: true

module WebinarRu
  module Entities
    # Create Event or Session result contain `id` and `url`
    class CreateResult
      extend Dry::Initializer

      option :id
      option :url, optional: true
    end
  end
end
