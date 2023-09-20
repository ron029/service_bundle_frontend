module CreateSession
  extend ActiveSupport::Concern
  # require Rails.root.join('lib/tasks/json_web_token')
  require 'json_web_token'
  def jwt_session_create(user_id)
    user = User.find_by(id: user_id)
    if user
      payload = { 'user_id' => user.id }
      JsonWebToken.encode(payload)
    else
      nil
    end
  end
end

  # def jwt_session_create(user_id)
  #   user = User.find_by(id: user_id)
  #   session = user.sessions.build
  #   if user && session.save
  #     payload = { 'user_id' => user.id }
  #     return JsonWebToken.encode(payload)
  #   else
  #     return nil
  #   end
  # end
