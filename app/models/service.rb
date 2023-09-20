class Service < ApplicationRecord
  before_save :round_price_to_two_decimal_places

  belongs_to :user
  belongs_to :service_category

  has_many :cart_items, dependent: :destroy
  has_many :time_slots, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 300 }
  validates :image, presence: true
  validates :price, presence: true

  private

  def round_price_to_two_decimal_places
    price.round(2) if price.present?
  end
end
