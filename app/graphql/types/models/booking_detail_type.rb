module Types
  module Models
    class BookingDetailType < Types::BaseObject
      field :id, ID, null: false
      field :name_of_customer, String, null: false
      field :services, String, null: false
      field :date, GraphQL::Types::ISO8601Date, null: false
      field :time, String, null: false
      field :service_categories, String, null: false
      field :amount, Float, null: false
      field :status, String, null: false
      field :booking_id, ID, null: false
      field :cart_date, GraphQL::Types::ISO8601Date, null: false
    end
  end
end
