class ServiceCategory < ApplicationRecord
  has_many :services

  validates :name, presence: true
  validates :image, presence: true
  validates :description, presence: true, length: { maximum: 300 }
end
