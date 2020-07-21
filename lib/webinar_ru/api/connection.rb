# frozen_string_literal: true

module WebinarRu
  module Api
    # Connection for client
    # The keys used in options are
    # * :+timeout+: timeout in seconds
    class Connection
      # Makes the request by taking rack env and returning rack response
      #
      # @param  [Hash<String, Object>] env Rack environment
      # @return [Array] Rack-compatible response
      #
      attr_accessor :timeout

      def call(env)
        request = Rack::Request.new(env)
        with_logger_for request do
          open_http_connection_for request do |http|
            res = http.request build_from(request)
            [res.code.to_i, Hash(res.header), Array(res.body)]
          end
        end
      end

      private

      def open_http_connection_for(req)
        Net::HTTP.start req.host, req.port, use_ssl: req.ssl?,
                                            open_timeout: @timeout,
                                            read_timeout: @timeout do |http|
          yield(http)
        end
      end

      def build_from(request)
        uri     = URI request.url
        body    = request.body
        type    = request.env["REQUEST_METHOD"].capitalize
        headers = request.env["HTTP_Variables"]

        Net::HTTP.const_get(type).new(uri).tap do |req|
          req.body = body
          headers.each { |key, val| req[key] = val }
        end
      end

      def with_logger_for(request)
        logger = request.logger
        log_request(logger, request)
        yield.tap { |response| log_response(logger, response) }
      end

      def log_request(logger, request)
        return unless logger

        logger.info(self) { "sending request:" }
        logger.info(self) { " Url     | #{request.url}" }
        logger.info(self) { " Headers | #{request.env['HTTP_Variables']}" }
        logger.info(self) { " Body    | #{request.body}" }
      end

      def log_response(logger, response)
        return unless logger

        status, headers, body = Array response
        logger.info(self) { "receiving response:" }
        logger.info(self) { " Status  | #{status}" }
        logger.info(self) { " Headers | #{headers}" }
        logger.info(self) { " Body    | #{body}" }
      end
    end
  end
end
