class User < ApplicationRecord
  before_save { self.email = email.downcase }
  before_save :set_role_if_empty

  has_many :carts, dependent: :destroy
  has_many :services, dependent: :destroy

  VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i.freeze

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :contact_number, presence: true
  validates :password, presence: true, length: { minimum: 6, maximum: 50 }, on: :create
  validates :password_confirmation, presence: true, on: :create
  validates :role, presence: true

  has_secure_password

  enum role: { customer: 0, admin: 1, manager: 2 }

  private

  def set_role_if_empty
    self.role = 2 if User.count.zero?

    if PaymentOption.count.zero?
      PaymentOption.create(name: 'Over The Counter')
      PaymentOption.create(name: 'Bank Deposit')
    end
  end
end
