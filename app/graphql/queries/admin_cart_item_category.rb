module Queries
  class AdminCartItemCategory < AdminQueries
    graphql_name 'AdminCartItemCategory'
    type [Types::Models::CartItemType], null: false
    argument :status, Integer, required: true

    def resolve(status:)
      services = Service.where(user_id: current_user.id)

      # Find the cart items associated with those services
      cart_item_ids = services.pluck(:id)
      CartItem.where(service_id: cart_item_ids)
      .where(status: status)
    end
  end
end
