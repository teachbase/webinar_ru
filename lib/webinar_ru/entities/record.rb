module WebinarRu
  module Entities
    # Record entity
    #
    # - option `:id` [String]
    # - option `:name` [String]
    # - option `:is_viewable` [Boolean]
    # - option `:has_password` [Boolean]
    # - option `:size` [Integer]
    # - option `:create_at` [String]
    # - option `:url` [String]
    class Record
      extend Dry::Initializer

      option :id, proc(&:to_s)
      option :name
      option :isViewable, as: :is_viewable
      option :hasPassword, as: :has_password
      option :size, proc(&:to_i)
      option :createAt, as: :create_at
      option :link, as: :url
    end
  end
end
