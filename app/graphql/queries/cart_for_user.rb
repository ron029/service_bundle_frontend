module Queries
  class CartForUser < AuthorisedQueries
    type Types::Models::CartType, null: false

    def resolve

      user1 = User.find_by(id: current_user.id)

      # Find the cart(s) with status "pending" for user1 and include service and service category details
      carts = Cart.joins(cart_items: { service: :service_category })
                  .where(status: 'pending')
                  .where(cart_items: { user_id: user1.id })
                  .distinct

      # Get details of the associated cart_items including service and service category names
      cart_items_details = []

      carts.each do |cart|
        cart_items = cart.cart_items
        cart_items.each do |cart_item|
          cart_items_details << {
            cart_id: cart.id,
            service_id: cart_item.service_id,
            service_name: cart_item.service.name,
            service_category_name: cart_item.service.service_category.name,
            date: cart_item.date,
            time: cart_item.time,
            status: cart_item.status
            # Add other details as needed
          }
        end
      end

      # cart_items_details now contains the details of cart_items with service and service category names

    end
  end
end
