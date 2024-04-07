class Authentication
  class << self
    def authorize_token(token)
      payload, _ = JWT.decode(token, nil, false)
      user = User.find(payload['user_id'])
      raise JWT::DecodeError, 'Access token is invalid!' if user.public_key.nil?

      rsa_public = OpenSSL::PKey::RSA.new(user.public_key)
      payload, _ = JWT.decode(token, rsa_public, true, algorithm: 'RS256')
      payload
    end

    def generate_token(user)
      rsa_private = OpenSSL::PKey::RSA.generate(2048)
      public_key = rsa_private.public_key.to_pem

      payload = {
        user_id: user.id,
        exp: 30.days.from_now.to_i
      }
      token = JWT.encode(payload, rsa_private, 'RS256')
      [token, public_key]
    end
  end
end
