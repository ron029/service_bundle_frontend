module Queries
  class AdminCartItem < AdminQueries
    type [Types::Models::CartItemType], null: false

    argument :status, Integer, required: false
    def resolve(status: nil)
      status = [0, 1, 2, 3, 4] if status.nil?
  status = [1, 2] if status == 2

  if current_user.admin?
    # User is an admin, so apply the filter
    # Find the services owned by user1
    services_owned_by_user1 = Service.where(user_id: current_user.id)

    # Find the cart item IDs associated with those services
    cart_item_ids = CartItem.where(service_id: services_owned_by_user1.pluck(:id)).pluck(:id)

    # Filter cart items by status and service ownership
    filtered_cart_items = CartItem.includes(service: [:user, :service_category])
                                  .where(status: status, id: cart_item_ids)
                                  .map do |cart_item|
      {
        id: cart_item.id,
        date: cart_item.date,
        time: cart_item.time,
        status: cart_item.status,
        service_name: cart_item.service.name,
        service_category: cart_item.service.service_category.name,
        user_name: cart_item.service.user.first_name,
        user_lastname: cart_item.service.user.last_name
      }
    end

    filtered_cart_items
  else
    # User is not an admin, so return all cart items without filtering
    CartItem.includes(service: [:user, :service_category])
            .where(status: status)
            .map do |cart_item|
      {
        id: cart_item.id,
        date: cart_item.date,
        time: cart_item.time,
        status: cart_item.status,
        service_name: cart_item.service.name,
        service_category: cart_item.service.service_category.name,
        user_name: cart_item.service.user.first_name,
        user_lastname: cart_item.service.user.last_name
      }
    end
  end
    end
  end
end
