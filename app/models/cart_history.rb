class CartHistory < ApplicationRecord
  before_save :update_cart_item_statuses

  belongs_to :cart
  belongs_to :payment_option

  VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i.freeze

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  # validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :contact_number, presence: true

  private

  def update_cart_item_statuses

    cart = self.cart
    if cart
      cart_items = cart.cart_items
  
      cart_items.each do |cart_item|
        # Update the status of each cart item to 1 without checking capacity
        cart_item.update_column('status', 1)
      end
  
      # Update the cart status to 1 (if needed)
      cart.update_column('status', 1)
    end
    
    # if cart
    #   cart_items = cart.cart_items
    #   problematic_cart_item = nil

    #   cart_items.each do |cart_item|
    #     if cart_item.fits_capacity?
    #       cart_item.update_column('status', 1)
    #     else
    #       cart_item.errors.add(:base, "Time slot capacity is full for cart item with ID #{cart_item.id}")
    #       problematic_cart_item = cart_item
    #       break
    #     end
    #   end

    #   if problematic_cart_item
    #      raise ActiveRecord::RecordInvalid.new(problematic_cart_item)
    #   else
    #     cart.update_column('status', 1)
    #   end
    # end
  end
end
