module Queries
  class ServiceCategories < AuthorisedQueries
    type [Types::Models::ServiceCategoryType], null: false
    argument :id, ID, required: false

    def resolve(id: nil)
      result = id.nil? ? ServiceCategory.all : ServiceCategory.find_by(id: id)
      Array.wrap(result)
    end
  end
end
