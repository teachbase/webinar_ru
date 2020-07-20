# frozen_string_literal: true

RSpec.describe WebinarRu::Api::V3::Client, :test_connection do
  describe "files" do
    describe "GET #events /fileSystem/file/{file_id}" do
      subject(:get_file_info) { client.files(id: file_id).show }

      let(:file_id) { "15426205" }
      let(:expected_request) do
        {
          path: "/v3/fileSystem/file/#{file_id}",
          request_method: "GET",
          token: token,
          host: host
        }
      end
      let(:response) { File.read("spec/fixtures/file.json") }

      it_behaves_like "sends request"

      it "returns file info" do
        value = get_file_info.value
        expect(value).to have_attributes(
          id: file_id,
          download_url: "https://events-storage.webinar.ru/api-storage/123.pdf"
        )
      end
    end
  end
end
