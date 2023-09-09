module Queries
  class Services < AuthorisedQueries
    type [Types::Models::ServiceType], null: false
    argument :id, ID, required: false

    def resolve(id: nil)
      result = id.nil? ? Service.all : Service.find_by(id: id)
      Array.wrap(result)
    end
  end
end
