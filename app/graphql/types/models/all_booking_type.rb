module Types
  module Models
    class AllBookingType < Types::BaseObject
      field :confirmed, [Types::Models::CartItemType], null: false
      field :confirmed_count, Integer, null: false
      field :cancelled, [Types::Models::CartItemType], null: false
      field :cancelled_count, Integer, null: false
      field :upcoming, [Types::Models::CartItemType], null: false
      field :upcoming_count, Integer, null: false
      field :most_booked_services, [Types::Models::ServiceType], null: false

      def most_booked_services
        services_ordered_by_booking_count = Service
          .joins(:cart_items)
          .where(cart_items: { status: [2, 3, 4] }) # Filter based on cart_items' status
          .select('services.*, COUNT(cart_items.id) AS booking_count')
          .group('services.id')
          .order('booking_count DESC')
      
        # Access the services in the desired order
        services = services_ordered_by_booking_count.all
      end
    end
  end
end
