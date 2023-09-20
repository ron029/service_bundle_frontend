module Queries
  class CartHistories < AuthorisedQueries
    type [Types::Models::CartHistoryType], null: false
    argument :id, ID, required: false

    def resolve(id: nil)
      result = id.nil? ? CartHistory.all : CartHistory.find_by(id: id)
      Array.wrap(result)
    end
  end
end
