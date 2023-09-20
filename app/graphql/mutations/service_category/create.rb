# Frozen_string_literal: true

module Mutations
  module ServiceCategory
    class Create < AdminMutation
      graphql_name 'CreateServiceCategory'
      # often we will need input types for specific mutation
      # in those cases we can define those input types in the mutation class itself

      argument :name, String, required: true
      argument :description, String, required: true
      argument :image, String, required: true

      field :errors, [String], null: true
      field :service_category, Types::Models::ServiceCategoryType, null: true

      def resolve(params)
        service_category = ServiceCategories::Persistence.new(current_user).create(params)
        {
          errors: service_category.errors.full_messages,
          service_category: service_category
        }
      end
    end
  end
end
