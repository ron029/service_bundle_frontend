module Users
  class Persistence
    attr_reader :current_user, :errors

    def initialize(current_user = nil)
      @current_user = current_user
      @errors = ActiveModel::Errors.new(self)
    end

    def create(params)
      return current_user if current_user.present?
      user = User.create(
        first_name: params[:first_name],
        last_name: params[:last_name],
        contact_number: params[:mobile_number],
        role: params[:role],
        email: params[:auth_provider]&.[](:credentials)&.[](:email),
        password: params[:auth_provider]&.[](:credentials)&.[](:password),
        password_confirmation: params[:auth_provider]&.[](:credentials)&.[](:password_confirmation)
      )
      errors = user.valid? ? [] : user.errors.full_messages
      { errors: errors, user: user }
    end

    def update(params)
      user = User.find(params[:id])
      user.update(
        first_name: params[:first_name], last_name: params[:last_name],
        contact_number: params[:contact_number], role: params[:role],
        email: params[:auth_provider]&.[](:credentials)&.[](:email),
        password: params[:auth_provider]&.[](:credentials)&.[](:password),
        password_confirmation: params[:auth_provider]&.[](:credentials)&.[](:password_confirmation)
      )
      user
    end

    def check_email(params)
      user = User.find_by(email: params[:email])
      user.nil? ? false : true
    end
  end
end
