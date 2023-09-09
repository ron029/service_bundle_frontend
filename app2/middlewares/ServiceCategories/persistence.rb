module ServiceCategories
  class Persistence
    attr_reader :current_user

    def initialize(current_user = nil)
      @current_user = current_user
    end

    def create(params)
      service_category = ServiceCategory.create(
        name: params[:name],
        image: params[:image],
        description: params[:description]
      )
      service_category
    end

    def update(params)
      service_category = ServiceCategory.find(params[:id])

      if service_category.update(
        name: params[:name],
        image: params[:image],
        description: params[:description],
      )
        # The update was successful, return the updated service
        service_category
      else
        # The update failed due to validation errors, return the service with an error message
        service_category.errors.full_messages.join(', ')
        service_category
      end
    end

    def delete(params)
      sc = ServiceCategory.find_by(id: params[:id])
      sc.destroy
    end
  end
end
