module Queries
  class TimeSlot < AdminQueries
    type [Types::Models::TimeSlotType], null: false
    argument :id, ID, required: false
    def resolve(id: nil)
      if id.nil?
        result = ::TimeSlot.all
      else
        result = ::TimeSlot.find_by(service_id: id)
      end
      # binding.pry
      Array.wrap(result)
    end
  end
end
