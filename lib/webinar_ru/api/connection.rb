# frozen_string_literal: true

require 'rate_throttle_client'

module WebinarRu
  module Api
    # Connection for client
    # The keys used in options are
    # * :+timeout+: timeout in seconds
    class Connection
      # Decorator for RateThrottleClient
      class ResponseDecorator < SimpleDelegator
        alias object __getobj__

        def status
          object.code.to_i
        end

        def header
          Hash(object.header)
        end

        def body
          Array(object.body)
        end
      end
      attr_accessor :timeout
      attr_reader :proxy

      def initialize(throttle: nil, timeout: 60, proxy: nil)
        @throttle = throttle || RateThrottleClient::ExponentialIncreaseProportionalDecrease.new
        @timeout = timeout
        @proxy = proxy
      end

      # Makes the request by taking rack env and returning rack response
      #
      # @param  [Hash<String, Object>] env Rack environment
      # @return [Array] Rack-compatible response
      def call(env)
        request = Rack::Request.new(env)
        res = @throttle.call { send_request(request) }
        [res.status, res.header, res.body]
      end

      private

      def send_request(request)
        with_logger_for request do
          open_http_connection_for request do |http|
            ResponseDecorator.new(
              http.request(build_from(request))
            )
          end
        end
      end

      def open_http_connection_for(req, &block)
        net_http = Net::HTTP.new(req.host, req.port, *proxy_params)
        net_http.use_ssl = req.ssl?
        net_http.open_timeout = @timeout
        net_http.read_timeout = @timeout
        net_http.start(&block)
      end

      def proxy_params
        return [] if proxy.nil?

        uri = URI(proxy)
        [uri.host, uri.port]
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

        headers = request.env['HTTP_Variables'].dup
        headers.delete("x-auth-token")
        logger.info(self) { " Headers | #{headers}" }

        logger.info(self) { " Body    | #{request.body.to_s.gsub(/(password=[^&]+)&/, '')}" }
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
