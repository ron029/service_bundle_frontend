module CartHistories
  class Persistence
    attr_reader :current_user

    def initialize(current_user = nil)
      @current_user = current_user
    end

    def create(params)
      current_user_cart = current_user.carts.where(status: 'pending').first # Use .first to get the first matching cart

      raise ActiveRecord::RecordNotFound, 'Empty Cart' unless current_user_cart

      cart_history = CartHistory.new(
        cart_id: current_user_cart.id, payment_option_id: params[:payment_option_id],
        first_name: params[:first_name], last_name: params[:last_name],
        contact_number: params[:contact_number], email: params[:email]
      )
      unless cart_history.valid?
        # binding.pry
        error_message = cart_history.errors.full_messages.join(', ')
        raise ActiveRecord::RecordInvalid.new(error_message)
      end

      c = cart_history.save!
      raise ActiveRecord::RecordInvalid.new(c.errors.full_messages.join(', ')) if !c
      CartHistory.find_by(id: cart_history.id)
    end

    def update(params)
      # user = User.find(params[:id])
      # user.update(
      #   first_name: params[:first_name], last_name: params[:last_name],
      #   contact_number: params[:contact_number], role: params[:role],
      #   email: params[:auth_provider]&.[](:credentials)&.[](:email),
      #   password: params[:auth_provider]&.[](:credentials)&.[](:password),
      #   password_confirmation: params[:auth_provider]&.[](:credentials)&.[](:password_confirmation)
      # )
      # user
    end

    def create_cart_history(cart_id, params)
      cart_history = CartHistory.create(
          cart_id: cart_id, payment_option_id: params[:payment_option_id],
          first_name: params[:first_name], last_name: params[:last_name],
          contact_number: params[:contact_number], email: params[:email]
        )
      cart_history.id # Return the cart object, not its id
    end
  end
end
