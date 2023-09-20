module Queries
  class TimeSlotOne < AuthorisedQueries
    type Types::Models::TimeSlotType, null: false
    argument :id, ID, required: false
    def resolve(id: nil)
      time_slot = ::TimeSlot.find_by(id: id)

      if time_slot
        # Convert start_time and end_time to time objects
        time_slot.start_time = time_slot.start_time.strftime('%H:%M:%S')
        time_slot.end_time = time_slot.end_time.strftime('%H:%M:%S')
      end
      time_slot
    end
  end
end
