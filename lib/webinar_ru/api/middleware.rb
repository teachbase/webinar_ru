# frozen_string_literal: true

module WebinarRu
  module Api
    # Middleware for Client
    class Middleware
      def call(env)
        # All in one, because each call middleware in client rewrite previous middleware. =(
        env["rack.logger"] = WebinarRu.logger
        env["rack.input"] = camelize_query(env["rack.input"])
        env["QUERY_STRING"] = camelize_query(env["QUERY_STRING"])
        @app.call(env)
      end

      private

      def initialize(app)
        @app = app
      end

      def camelize_query(string)
        return unless string

        params = URI.decode_www_form(string).map do |key, value|
          [WebinarRu::Utils.camelize(key), value]
        end
        URI.encode_www_form(params)
      end

      def camelize_params(json)
        return unless json

        params = JSON.parse(json)
        WebinarRu::Utils.camelize_keys(params).to_json
      rescue JSON::ParserError
        camelize_query(json)
      end
    end
  end
end
