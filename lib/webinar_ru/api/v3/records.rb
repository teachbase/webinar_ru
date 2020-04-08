# frozen_string_literal: true

WebinarRu::Api::V3::Client.scope :records do
  format :form
  path { "records" }

  option :id, optional: true

  operation :index do
    http_method :get

    option :from
    option :to,      optional: true
    option :file_id, optional: true, as: :id
    option :period,  optional: true
    option :user_id, optional: true

    let(:converted_params) do
      {
        from: from && Time.at(from).strftime(WebinarRu::Api::V3::Client::TIME_FORMAT),
        to: to && Time.at(to).strftime(WebinarRu::Api::V3::Client::TIME_FORMAT),
        id: id
      }.compact
    end

    query { safe_options.merge(converted_params) }
    let(:response_handler) do
      WebinarRu::Api::V3::Responses::EntityList.new(
        WebinarRu::Entities::Record
      )
    end
  end

  operation :update do
    http_method :put
    path { id.to_s }

    option :is_viewable
    option :password

    body { safe_options }
  end

  operation :destroy do
    http_method :delete
    path { id.to_s }
  end

  operation :share do
    http_method :post
    path { "#{id}/share" }
  end

  scope :conversions do
    path { "#{id}/conversions" }

    option :conversion_id, optional: true

    operation :create do
      http_method :post

      option :quality
      option :view

      body { safe_options }
      let(:response_handler) do
        WebinarRu::Api::V3::Responses::Entity.new(
          WebinarRu::Entities::CreateResult
        )
      end
    end

    operation :status do
      http_method :get
      path { conversion_id.to_s }

      let(:response_handler) do
        WebinarRu::Api::V3::Responses::Entity.new(
          WebinarRu::Entities::ConversionStatus
        )
      end
    end
  end
end
