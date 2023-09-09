# Frozen_string_literal: true

module Mutations
  module User
    class Create < BaseMutation
      graphql_name 'CreateUser'
      # often we will need input types for specific mutation
      # in those cases we can define those input types in the mutation class itself
      class AuthProviderSignupData < Types::BaseInputObject
        graphql_name 'CreateUser'
        argument :credentials, Types::AuthProviderCredentialsInput, required: false
      end

      argument :first_name, String, required: true
      argument :last_name, String, required: true
      argument :mobile_number, String, required: true
      argument :role, Integer, required: true
      argument :auth_provider, AuthProviderSignupData, required: true

      field :errors, [String], null: true
      field :user, Types::Models::UserType, null: true

      def resolve(params)
        user = Users::Persistence.new(current_user).create(params)
        {
          errors: user[:errors],
          user: user[:user]
        }
      end
    end
  end
end
