module Services
  class Persistence
    extend ActiveModel::Naming
    attr_reader :current_user, :errors, :service
    
    def initialize(current_user = nil)
      @errors = ActiveModel::Errors.new(self)
      @current_user = current_user
    end

    def create(params)
      service = Service.create(
        user_id: current_user.id,
        service_category_id: params[:service_category_id],
        name: params[:name],
        description: params[:description],
        price: params[:price],
        image: params[:image]
      )
      errors = service.valid? ? [] : service.errors.full_messages
      { errors: errors, service: service }
    end

    def update(params)
      service = Service.find(params[:id])
      user_id = current_user.id != service.id ? service.user_id : current_user.id
      service.update(
        user_id: user_id,
        service_category_id: params[:service_category_id],
        name: params[:name],
        description: params[:description],
        price: params[:price],
        image: params[:image]
      )
      service
    end

    def create_cart
      cart = Cart.create(user_id: current_user.id, status: 0)
      cart.id # Return the cart object, not its id
    end
  end
end
