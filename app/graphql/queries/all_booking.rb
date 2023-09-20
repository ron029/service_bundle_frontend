module Queries
  class AllBooking < AuthorisedQueries
    type Types::Models::AllBookingType, null: false

    def resolve
      confirmed = CartItem.where(status: 2)
      confirmed_count = confirmed.count
      cancelled = CartItem.where(status: 3)
      cancelled_count = cancelled.count
      upcoming = CartItem.where(status: 4)
      upcoming_count = upcoming.count
      {
        confirmed: confirmed,
        confirmed_count: confirmed_count,
        cancelled: cancelled,
        cancelled_count: cancelled_count,
        upcoming: upcoming,
        upcoming_count: upcoming_count
      }
    end
  end
end
