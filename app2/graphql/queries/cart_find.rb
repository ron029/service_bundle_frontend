module Queries
  class CartFind < AuthorisedQueries
    type Types::Models::CartType, null: false
    argument :id, ID, required: false

    def resolve(id:)
      result = id.nil? ? Cart.all : Cart.find_by(id: id)
      Array.wrap(result)
    end
  end
end