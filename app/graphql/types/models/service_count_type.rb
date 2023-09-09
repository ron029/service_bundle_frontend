module Types
  module Models
    class ServiceCountType < Types::BaseObject
      field :service_id, ID, null: false
      field :count, Integer, null: false
      field :service, Types::Models::ServiceType, null: false
      field :image, String, null: false

      def service
        Service.find_by(id: object[:service_id])
      end
    end
  end
end
