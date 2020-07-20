# frozen_string_literal: true

module WebinarRu
  module Entities
    # Common event and session options
    class WebinarBase
      extend Dry::Initializer

      option :id, proc(&:to_s)
      option :status, proc { |val| val.to_s.downcase }, optional: true
      option :access, proc(&:to_i), optional: true
      option :name, optional: true
      option :description, optional: true
      option :startsAt, as: :starts_at, optional: true
      option :endsAt, as: :ends_at, optional: true
      option :createUserId, as: :create_user_id, optional: true
      option :type, optional: true
    end
  end
end
