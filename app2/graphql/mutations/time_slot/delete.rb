# Frozen_string_literal: true

module Mutations
  module TimeSlot
    class Delete < AdminMutation
      graphql_name 'DeleteTimeSlot'

      argument :id, ID, required: true

      field :errors, [String], null: true
      field :time_slot, Types::Models::TimeSlotType, null: true

      def resolve(params)
        time_slot = TimeSlots::Persistence.new(current_user).delete(params)
        {
          errors: time_slot.errors.full_messages,
          time_slot: time_slot
        }
      end
    end
  end
end
