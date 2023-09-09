module Types
  module Models
    class UserType < Types::BaseObject
      field :id, ID, null: false
      field :first_name, String, null: false
      field :last_name, String, null: false
      field :contact_number, String, null: false
      field :email, String, null: false
      field :role, String, null: false
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
      field :count, Integer, null: true

      def count
        User.count
      end
    end
  end
end
