# frozen_string_literal: true

require 'evil-client'
require 'tzinfo'
require "webinar_ru/version"
require 'webinar_ru/utils'
require "webinar_ru/result"
require "webinar_ru/entities/create_result"
require "webinar_ru/entities/webinar_base"
require "webinar_ru/entities/session"
require "webinar_ru/entities/file_info"
require "webinar_ru/entities/record"
require "webinar_ru/entities/conversion_status"
require "webinar_ru/entities/event"
require "webinar_ru/entities/event_detail"
require "webinar_ru/entities/session_detail"
require "webinar_ru/entities/registration_result"
require "webinar_ru/entities/participant"
require "webinar_ru/api/v3/responses/base"
require "webinar_ru/api/v3/responses/create_event"
require "webinar_ru/api/v3/responses/create_session"
require "webinar_ru/api/v3/responses/entity_list"
require "webinar_ru/api/v3/responses/entity"
require "webinar_ru/api/v3/client"
require "webinar_ru/api/v3/events"
require "webinar_ru/api/v3/users"
require "webinar_ru/api/v3/event_sessions"
require "webinar_ru/api/v3/organization"
require "webinar_ru/api/v3/participants"
require "webinar_ru/api/v3/stats"
require "webinar_ru/api/v3/records"
require "webinar_ru/api/v3/files"
require "webinar_ru/api/connection"

# Main configuration module
module WebinarRu
  class << self
    attr_accessor :logger

    # Returns configured client for webinar.ru API
    # @param token [String] you personal secret token
    # @param [String] domain
    # @param [String] host
    # @param [Class<Evil::Client>] client
    # @param [String] proxy
    # @return [Evil::Client]
    def client(token:, domain: nil, host: nil, client: Api::V3::Client, proxy: nil)
      client.connection = Api::Connection.new(proxy: proxy) if proxy
      client.new(domain: domain, host: host, token: token)
    end

    # Setup connection timeout
    def timeout=(val)
      Api::V3::Client.connection.timeout = val
    end
  end

  Api::V3::Client.connection = Api::Connection.new
  self.timeout = 60
end
