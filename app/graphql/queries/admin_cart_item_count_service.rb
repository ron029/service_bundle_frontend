module Queries
  class AdminCartItemCountService < AuthorisedQueries
    type [Types::Models::ServiceCountType], null: true

    def resolve
      # CartItem.all
      if current_user.admin?
        CartItem
          .joins(:service)
          .where(services: { user_id: current_user.id })
          .where(status: %w[paid completed confirmed])
          .group(:service_id)
          .select('service_id, COUNT(*) as count')
          .map { |result| { service_id: result.service_id, count: result.count } }
      else
        # .where(services: { user_id: current_user.id })
        CartItem
        .joins(:service)
        .where(status: %w[paid completed confirmed])
        .group(:service_id)
        .select('service_id, COUNT(*) as count')
        .map { |result| { service_id: result.service_id, count: result.count } }
      end
    end
  end
end
