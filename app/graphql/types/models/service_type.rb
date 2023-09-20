module Types
  module Models
    class ServiceType < Types::BaseObject
      field :id, ID, null: false
      field :user_id, Types::Models::UserType, null: false
      field :service_category_id, Types::Models::ServiceCategoryType, null: false
      field :name, String, null: false
      field :description, String, null: false
      field :image, String, null: false
      field :price, Integer, null: false
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
      field :time_slot, [Types::Models::TimeSlotType], null: true do
        argument :start_date, GraphQL::Types::ISO8601Date, required: false
        argument :end_date, GraphQL::Types::ISO8601Date, required: false
        argument :start_time, String, required: false
        argument :end_time, String, required: false
      end
      field :service_categories, [Types::Models::ServiceCategoryType], null: true

      def service_categories
        ServiceCategory.all
      end

      def time_slot(start_date: nil, end_date: nil, start_time: nil, end_time: nil)
        time_slots = object.time_slots
        time_slots = time_slots.where(start_date: start_date) if start_date
        time_slots = time_slots.where(end_date: end_date) if end_date
        time_slots = time_slots.where(start_time: start_time) if start_time
        time_slots = time_slots.where(end_time: end_time) if end_time
        formatted_time_slots = time_slots.to_a.map do |time_slot|
          {
            id: time_slot.id, # Include the time slot ID
            start_date: time_slot.start_date.strftime('%Y-%m-%d'), # Format date as 'YYYY-MM-DD'
            end_date: time_slot.end_date.strftime('%Y-%m-%d'), # Format date as 'YYYY-MM-DD'
            start_time: time_slot.start_time.strftime('%H:%M:%S'), # Format time as 'HH:MM:SS'
            end_time: time_slot.end_time.strftime('%H:%M:%S') # Format time as 'HH:MM:SS'
          }
        end
        formatted_time_slots
      end

      def user_id
        object.user
      end

      def service_category_id
        object.service_category
      end
    end
  end
end
