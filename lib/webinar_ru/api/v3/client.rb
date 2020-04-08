# frozen_string_literal: true

require 'webinar_ru/api/middleware'

module WebinarRu
  module Api
    module V3
      # http client for webinar ru API
      class Client < ::Evil::Client
        DOMAIN = 'userapi'
        HOST = 'webinar.ru'
        VERSION = 3
        TIME_FORMAT = "%Y-%m-%dT%H:%M:%S"

        middleware WebinarRu::Api::Middleware

        option :domain, optional: true
        option :host, optional: true
        option :token

        path     { "https://#{domain || DOMAIN}.#{host || HOST}/v#{VERSION}" }
        security { key_auth 'x-auth-token', token }

        response 200, 201, 204 do |_status, _headers, (body, _)|
          response_handler.call(body)
        end

        response 400, 401, 403, 404, 405, 409, 500 do |_status, _headers, (body, _)|
          WebinarRu::Result.failure(body)
        end

        let(:safe_options) do
          options.except(:domain, :token, :host, :id)
        end

        # response_handler parse and wrap data
        # you can redefine handler for scope or operation
        let(:response_handler) { WebinarRu::Api::V3::Responses::Base.new }
      end
    end
  end
end
