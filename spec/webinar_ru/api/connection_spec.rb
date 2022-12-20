# frozen_string_literal: true

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

    it "sends request" do
      stub = stub_request(
        :get, "https://test.webinar.ru/v3/eventsessions/some-uniq-id"
      ).with(
        headers: {
          "x-auth-token" => "test-token", "Content-Type" => "application/x-www-form-urlencoded"
        }
      ).to_return(body: "abc", status: 200, headers: { "test" => "123" })

      call_connection
      expect(stub).to have_been_requested
    end

    context "with proxy" do
      before { WebMock.allow_net_connect! }
      let(:conn) { described_class.new(proxy: proxy) }

      context "when proxy address with port" do
        let(:proxy) { "https://teachbase.com:8888" }

        it "connects to proxy first" do
          expect { call_connection }.to raise_error(SocketError,
                                                    %r{ open TCP connection to #{proxy} })
        end
      end

      context "when proxy as host" do
        let(:proxy) { "https://teachbase.com" }

        it "connects to proxy first" do
          expect { call_connection }.to raise_error(SocketError,
                                                    /open TCP connection to #{proxy}:443/)
        end
      end

      after { WebMock.disable_net_connect! }
    end
  end
end
