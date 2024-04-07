require 'rails_helper'

RSpec.describe Authentication do
  describe '.authorize_token' do
    let(:user) { create(:user) }
    let(:rsa_private) { OpenSSL::PKey::RSA.generate(2048) }
    let(:rsa_public) { rsa_private.public_key }
    let(:exp_time) { 30.days.from_now.to_i }
    let(:token) { JWT.encode({ user_id: user.id, exp: exp_time}, rsa_private, 'RS256') }

    it 'returns the decoded payload if the token is valid' do
      allow(User).to receive(:find).with(user.id).and_return(user)
      allow(user).to receive(:public_key).and_return(rsa_public.to_pem)

      decoded_payload = Authentication.authorize_token(token)

      expect(decoded_payload).to eq({ 'user_id' => user.id, 'exp' => exp_time})
      expect(decoded_payload['exp']).to eq(exp_time)
    end

    it 'raises JWT::DecodeError if the user public key is nil' do
      allow(User).to receive(:find).with(user.id).and_return(user)
      allow(user).to receive(:public_key).and_return(nil)

      expect {
        Authentication.authorize_token(token)
      }.to raise_error(JWT::DecodeError, 'Access token is invalid!')
    end
  end

  describe '.generate_token' do
    let(:user) { create(:user) }

    it 'returns a token and public key' do
      rsa_private = instance_double(OpenSSL::PKey::RSA)
      rsa_public = instance_double(OpenSSL::PKey::RSA)
      allow(OpenSSL::PKey::RSA).to receive(:generate).with(2048).and_return(rsa_private)
      allow(rsa_private).to receive(:public_key).and_return(rsa_public)
      allow(rsa_public).to receive(:to_pem).and_return('public_key')
      allow(JWT).to receive(:encode).and_return('token')

      token, public_key = Authentication.generate_token(user)

      expect(token).to eq('token')
      expect(public_key).to eq('public_key')
    end
  end
end
