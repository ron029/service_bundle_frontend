module Types
  module Models
    class CartType < Types::BaseObject
      field :id, ID, null: false
      field :user_id, Types::Models::UserType, null: false
      field :status, Integer, null: true
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    end

    def user_id
      object.user
    end
  end
end
