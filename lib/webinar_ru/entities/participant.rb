# frozen_string_literal: true

module WebinarRu
  module Entities
    # Participant entity
    # option :id [String]
    # option :name [String]
    # option :second_name [String]
    # option :email [String]
    # option :role [String]
    # option :register_status [String]
    # option :payment_status [String]
    # option :register_date [String]
    # option :visited [Boolean]
    class Participant
      extend Dry::Initializer

      option :id, proc(&:to_s)
      option :name, optional: true
      option :secondName, as: :second_name, optional: true
      option :email
      option :role
      option :registerStatus, optional: true, as: :register_status
      option :paymentStatus, optional: true, as: :payment_status
      option :registerDate, optional: true, as: :register_date
      option :visited, optional: true
    end
  end
end
