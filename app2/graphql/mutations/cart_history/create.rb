module Mutations
  module CartHistory
    class Create < Mutations::AuthorisedMutation
      graphql_name 'CreateCartHistory'

      argument :payment_option_id, ID, required: true
      argument :first_name, String, required: true
      argument :last_name, String, required: true
      argument :contact_number, String, required: true
      argument :email, String, required: true

      field :errors, [String], null: true
      field :cart_history, Types::Models::CartHistoryType, null: true

      def resolve(params)
        cart_history = CartHistories::Persistence.new(current_user).create(params)
        {
          errors: cart_history.errors.full_messages,
          cart_history: cart_history
        }
      end
    end
  end
end
