# Frozen_string_literal: true

module Mutations
  module Service
    class Create < AdminMutation
      graphql_name 'CreateService'
      # often we will need input types for specific mutation
      # in those cases we can define those input types in the mutation class itself
      argument :service_category_id, ID, required: true
      argument :name, String, required: true
      argument :description, String, required: true
      argument :image, String, required: true
      argument :price, Integer, required: true

      field :errors, [String], null: true
      field :service, Types::Models::ServiceType, null: true

      def resolve(params)
        service = Services::Persistence.new(current_user).create(params)
        {
          errors: service[:errors],
          service: service[:service]
        }
      end
    end
  end
end
