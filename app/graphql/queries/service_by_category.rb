module Queries
  class ServiceByCategory < AuthorisedQueries
    type [Types::Models::ServiceType], null: false

    argument :id, ID, required: true

    def resolve(id:)
      result = Service.where(service_category_id: id)
      Array.wrap(result)
    end
  end
end
