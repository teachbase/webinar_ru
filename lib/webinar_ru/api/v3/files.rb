# frozen_string_literal: true

WebinarRu::Api::V3::Client.scope :files do
  format :form
  path { "fileSystem" }

  option :id, optional: true

  operation :show do
    http_method :get

    path { "file/#{id}" }

    let(:response_handler) do
      WebinarRu::Api::V3::Responses::Entity.new(
        WebinarRu::Entities::FileInfo
      )
    end
  end
end
