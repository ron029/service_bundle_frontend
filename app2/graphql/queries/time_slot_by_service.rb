module Queries
  class TimeSlotByService < AdminQueries
    type [Types::Models::TimeSlotType], null: false
    argument :id, ID, required: true
    def resolve(id: nil)

      time_slot = ::TimeSlot.where(service_id: id)
      Array.wrap(time_slot)
    end
  end
end
