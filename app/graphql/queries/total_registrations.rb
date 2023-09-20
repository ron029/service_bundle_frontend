module Queries
  class TotalRegistrations < ManagerQueries
    type Types::Models::TotalRegistrationType, null: false

    def resolve
      users = User.all.where(role: ["admin","customer"])
      count = users.count
      { users: users, count: count }
    end
  end
end
