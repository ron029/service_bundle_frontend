module Types
  module Models
    class ServiceCategoryType < Types::BaseObject
      field :id, ID, null: false
      field :name, String, null: true
      field :image, String, null: true
      field :description, String, null: true
    end
  end
end
