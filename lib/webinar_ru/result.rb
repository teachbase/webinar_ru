# frozen_string_literal: true

module WebinarRu
  # Result object
  # api methods returns result with value
  class Result
    class << self
      # Returns success result
      # @param [Object] value
      # @return [WebinarRu::Result]
      def success(value)
        new(value, true)
      end

      # Returns failure result
      # @param [Object] value
      # @return [WebinarRu::Result]
      def failure(value)
        new(value, false)
      end
    end

    attr_reader :value

    # @return [Boolean]
    def failure?
      !success?
    end

    # @return [Boolean]
    def success?
      @success
    end

    private

    def initialize(value, success)
      @value = value
      @success = success
    end
  end
end
