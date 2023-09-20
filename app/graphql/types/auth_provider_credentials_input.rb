module Types
  class AuthProviderCredentialsInput < BaseInputObject
    # the name is usually inferred by class name but can be overwritten
    graphql_name 'AUTH_PROVIDER_CREDENTIALS'

    argument :email, String, required: true
    argument :password, String, required: true
    argument :password_confirmation, String, required: false
  end
end
