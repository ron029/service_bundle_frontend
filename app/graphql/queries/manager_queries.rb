module Queries
  class ManagerQueries < AuthorisedQueries
    def ready?(**_args)
      return true if context[:current_user].manager?

      raise GraphQL::ExecutionError, 'Not allowed' unless context[:current_user].manager?
    end
  end
end
