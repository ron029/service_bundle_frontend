module Types
  module Models
    class TotalRegistrationType < Types::BaseObject
      field :users, [Types::Models::UserType], null: false, description: "List of registered users"
      field :count, Int, null: false, description: "Total number of registrations"
    end
  end
end
