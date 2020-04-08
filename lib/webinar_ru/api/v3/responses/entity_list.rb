# frozen_string_literal: true

module WebinarRu
  module Api
    module V3
      module Responses
        # Wrap array to list of entities
        class EntityList < Base
          def initialize(entity_klass)
            @entity_klass = entity_klass
          end

          private

          def process(data)
            Array(data).map do |item|
              @entity_klass.new(WebinarRu::Utils.symbolize_keys(item))
            end
          end
        end
      end
    end
  end
end
