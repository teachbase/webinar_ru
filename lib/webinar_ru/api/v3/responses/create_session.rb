# frozen_string_literal: true

module WebinarRu
  module Api
    module V3
      module Responses
        # Create event session response handler
        class CreateSession < Base
          private

          def process(data)
            WebinarRu::Entities::CreateResult.new(id: data["eventSessionId"], url: data["link"])
          end
        end
      end
    end
  end
end
