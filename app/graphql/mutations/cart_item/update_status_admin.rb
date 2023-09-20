module Mutations
  module CartItem
    class UpdateStatusAdmin < Mutations::AdminMutation
      graphql_name 'UpdateCartItemStatus'

      argument :id, ID, required: true
      argument :status, Integer, required: true

      field :errors, [String], null: true
      field :cart_item, Types::Models::CartItemType, null: true

      def resolve(params)
        cart_item = CartItems::Persistence.new.update(params)
        {
          errors: cart_item.errors.full_messages,
          cart_item: cart_item
        }
      end
    end
  end
end
