# app/graphql/resolvers/booking_details_resolver.rb
module Resolvers
  class BookingDetailsResolver
    def call
      CartItem.includes(:cart_history, service: :service_category).map do |cart_item|
        {
          booking_number: cart_item.id,
          booking_date: cart_item.cart_history.date,
          name_of_customer: "#{cart_item.cart_history.first_name} #{cart_item.cart_history.last_name}",
          service_name: cart_item.service.name,
          date: cart_item.date,
          time: cart_item.time,
          amount: cart_item.service.price.to_f
        }
        CartItem.includes(:service, cart_history: :payment_option)
                       .select('cart_items.id AS BookingNumber',
                               'cart_items.date AS BookingDate',
                               'CONCAT(cart_histories.first_name, " ", cart_histories.last_name) AS CustomerName',
                               'services.name AS ServiceName',
                               'cart_items.date AS BookingDate',
                               'cart_items.time AS BookingTime',
                               'cart_items.status AS BookingStatus',
                               'services.price AS ServiceAmount',
                               'payment_options.name AS PaymentOption')
                       .order(BookingDate: :desc)
      end
    end
  end
end
