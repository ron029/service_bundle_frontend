class PaymentOption < ApplicationRecord
  has_many :cart_histories
  validates :name, presence: true, length: { maximum: 100 }
end
