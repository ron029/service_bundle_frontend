module Queries
  class AdminService < AdminQueries
    type [Types::Models::ServiceType], null: false

    argument :id, Integer, required: false

    def resolve(id: nil)
      # binding.pry
      if current_user.manager?
        result = id.nil? ? Service.all : Service.find_by(id: id)
      else
        result = id.nil? ? current_user.services : current_user.services.find_by(id: id)
      end
      
      Array.wrap(result)
    end
  end
end
