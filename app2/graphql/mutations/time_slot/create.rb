# Frozen_string_literal: true

module Mutations
  module TimeSlot
    class Create < AdminMutation
      graphql_name 'CreateTimeSlot'

      argument :service_id, ID, required: true
      argument :date, String, required: true
      argument :start_time, String, required: true
      argument :end_time, String, required: true
      argument :capacity, String, required: true

      field :errors, [String], null: true
      field :time_slot, Types::Models::TimeSlotType, null: true

      def resolve(params)
        time_slot = TimeSlots::Persistence.new(current_user).create(params)
        {
          errors: time_slot.errors.full_messages,
          time_slot: time_slot
        }
      end
    end
  end
end
