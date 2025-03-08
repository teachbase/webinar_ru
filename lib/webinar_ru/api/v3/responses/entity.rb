# frozen_string_literal: true

module WebinarRu
  module Api
    module V3
      module Responses
        # Wrap data entity
        class Entity < Base
          def initialize(entity_klass)
            @entity_klass = entity_klass
          end

          private

          def process(data)
            @entity_klass.new(**WebinarRu::Utils.symbolize_keys(data))
          end
        end
      end
    end
  end
end
