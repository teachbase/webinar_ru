# frozen_string_literal: true

module WebinarRu
  module Api
    module V3
      module Responses
        # Base response handler
        class Base
          # @param [String] response
          # @return [WebinarRu::Result]
          def call(response)
            return WebinarRu::Result.success(nil) if response.nil?

            parse_response(response) { |data| WebinarRu::Result.success(process(data)) }
          end

          private

          def process(data)
            data
          end

          def parse_response(response)
            yield(JSON.parse(response))
          rescue JSON::ParserError => e
            WebinarRu::Result.failure("Error: `#{e.message}`, Response: `#{response}`")
          end
        end
      end
    end
  end
end
