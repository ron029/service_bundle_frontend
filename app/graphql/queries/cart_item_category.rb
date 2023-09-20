module Queries
  class CartItemCategory < AuthorisedQueries
    graphql_name 'CartItemCategory'
    type [Types::Models::CartItemType], null: false
    argument :status, Integer, required: true

    def resolve(status:)
      CartItem.where(cart_id: Cart.where(user_id: current_user.id).pluck(:id))
      .where(status: status)
    end
  end
end
