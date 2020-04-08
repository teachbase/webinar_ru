# frozen_string_literal: true

module WebinarRu
  module Api
    module V3
      module Responses
        # Create event response handler
        class CreateEvent < Base
          private

          def process(data)
            WebinarRu::Entities::CreateResult.new(id: data["eventId"], url: data["link"])
          end
        end
      end
    end
  end
end
