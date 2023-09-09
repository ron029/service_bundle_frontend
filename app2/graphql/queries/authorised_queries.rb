module Queries
  class AuthorisedQueries < Base
    def ready?(**_args)
      return true if context[:current_user].present?

      raise GraphQL::ExecutionError, 'Invalid user'
    end
  end
end
