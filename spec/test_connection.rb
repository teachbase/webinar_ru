# frozen_string_literal: true

class TestConnection
  def initialize(status, response)
    @response = response
    @status = status
    @request = {}
  end

  def call(env)
    @request = env
    [@status, { "Content-Type" => "application/json" }, [@response]]
  end

  def query
    string = @request['QUERY_STRING']
    return unless string

    URI.decode_www_form(string)
  end

  def path
    @request["PATH_INFO"]
  end

  def request_method
    @request["REQUEST_METHOD"]
  end

  def body
    return unless @request["rack.input"]

    URI.decode_www_form(@request["rack.input"]).to_h
  end

  def query_string
    @request["QUERY_STRING"]
  end

  def host
    @request["SERVER_NAME"]
  end

  def token
    @request.dig("HTTP_Variables", "x-auth-token")
  end

  def content_type
    @request.dig("HTTP_Variables", "Content-Type")
  end
end
