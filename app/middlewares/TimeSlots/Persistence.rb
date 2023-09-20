module TimeSlots
  class Persistence
    attr_reader :current_user

    def initialize(current_user = nil)
      @current_user = current_user
    end

    def create(params)
      TimeSlot.create!(
        service_id: params[:service_id],
        start_date: params[:start_date],
        end_date: params[:end_date],
        start_time: params[:start_time],
        end_time: params[:end_time],
        capacity: params[:capacity]
      )
    end

    def update(params)
      user = TimeSlot.find(params[:id])
      user.update(
        service_id: params[:service_id],
        start_date: params[:start_date],
        end_date: params[:end_date],
        start_time: params[:start_time],
        end_time: params[:end_time],
        capacity: params[:capacity]
      )
      user
    end

    def delete(params)
      ts = TimeSlot.find_by(id: params[:id])
      ts.destroy
    end

    def check_email(params)
      user = User.find_by(email: params[:email])
      user.nil? ? false : true
    end
  end
end
