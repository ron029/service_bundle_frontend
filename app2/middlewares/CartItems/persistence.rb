module CartItems
  class Persistence
    attr_reader :current_user

    def initialize(current_user = nil)
      @current_user = current_user
    end

    def create(params)
      current_user_cart = current_user.carts.where(status: 'pending').first # Use .first to get the first matching cart
      cart_id = if !current_user_cart
                  cart = Cart.create(user_id: current_user.id, status: 0)
                  cart.id
                else
                  current_user_cart.id
                end
      
      c = CartItem.create(
        cart_id: cart_id, service_id: params[:service_id],
        date: params[:date], time: params[:time], status: 0
      )
      # binding.pry
      rescue ActiveRecord::RecordInvalid => e
        c.errors.add(:base, "Error: #{c.errors.full_messages.join(', ')}")
    end

    def update(params)
      cart_item = CartItem.find(params[:id])
      cart_item.update_column("status", params[:status])
      cart_item
    end

    def create_cart
       # Return the cart object, not its id
    end
  end
end
