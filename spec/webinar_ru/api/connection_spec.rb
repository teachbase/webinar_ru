# frozen_string_literal: true

require "logger"

RSpec.describe WebinarRu::Api::Connection do
  describe "#call" do
    subject(:call_connection) { conn.call(env) }

    let(:conn) { described_class.new }
    let(:env) do
      {
        "REQUEST_METHOD" => "GET",
        "PATH_INFO" => "/v3/eventsessions/some-uniq-id",
        "SCRIPT_NAME" => "",
        "QUERY_STRING" => "",
        "SERVER_NAME" => "test.webinar.ru",
        "SERVER_PORT" => 443,
        "HTTP_Variables" => {
          "x-auth-token" => "test-token", "Content-Type" => "application/x-www-form-urlencoded"
        },
        "rack.version" => [1, 3],
        "rack.url_scheme" => "https",
        "rack.input" => nil,
        "rack.multithread" => false,
        "rack.multiprocess" => false,
        "rack.run_once" => false,
        "rack.hijack?" => false,
        "rack.logger" => nil
      }
    end
    let!(:stub) do
      stub_request(
        :get, "https://test.webinar.ru/v3/eventsessions/some-uniq-id"
      ).with(
        headers: {
          "x-auth-token" => "test-token", "Content-Type" => "application/x-www-form-urlencoded"
        }
      ).to_return(body: "abc", status: 200, headers: { "test" => "123" })
    end

    it "sends request" do
      call_connection
      expect(stub).to have_been_requested
    end

    context "with proxy" do
      let(:conn) { described_class.new(proxy: "https://teachbase.com:8888") }

      it "sends request" do
        call_connection
        expect(stub).to have_been_requested
      end
    end

    context "with logger" do
      let(:log_io) { StringIO.new }
      let(:log) { log_io.string }
      let(:env) do
        super().merge(
          "rack.logger" => Logger.new(log_io),
          "rack.input" => {
            "password" => "123",
            "description" => "test"
          }
        )
      end
      let(:headers) { log.scan(/Headers.*({.*})/).flatten.first }
      let(:body) { log.scan(/Body.*({.*})/).flatten.first }

      it "filters logs output" do
        call_connection
        expect(headers).not_to match("x-auth-token")
        expect(body).not_to match("password")
      end
    end
  end
end
