module Queries
  class CartItems < AuthorisedQueries
    type [Types::Models::CartItemType], null: false
    argument :id, ID, required: false

    def resolve(id: nil)
      result = id.nil? ? CartItem.all : CartItem.find_by(id: id)
      Array.wrap(result)
    end
  end
end
