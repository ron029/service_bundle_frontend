module Types
  class PriceScalar < GraphQL::Schema::Scalar
    description "Price that can be either an integer or a float"

    def self.coerce_input(value, _context)
      # Ensure the input value is either an integer or a float
      unless value.is_a?(Integer) || value.is_a?(Float)
        raise GraphQL::CoercionError, "Price must be an integer or a float"
      end

      value.to_f # Convert the input value to a float
    end

    def self.coerce_result(value, _context)
      # Ensure the result value is returned as a float
      value.to_f
    end
  end
end