# frozen_string_literal: true

module WebinarRu
  module Entities
    # FileInfo entity
    # contain download url
    #
    # - option `:id` [String]
    # - option `:download_url` [String]
    class FileInfo
      extend Dry::Initializer

      option :id, proc(&:to_s)
      option :downloadUrl, as: :download_url
    end
  end
end
