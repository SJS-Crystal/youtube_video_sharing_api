module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      return if current_user

      reject_unauthorized_connection
    end

    private

    def find_verified_user
      payload = Authentication.authorize_token(request.params[:token] || nil)
      User.find_by(id: payload['user_id'])
    rescue JWT::DecodeError
    rescue
    end
  end
end
