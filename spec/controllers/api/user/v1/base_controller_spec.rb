require 'rails_helper'

RSpec.describe Api::User::V1::BaseController, type: :controller do
  let(:user) { create(:user) }
  let(:token_and_public_key) { Authentication.generate_token(user) }
  let(:token) { token_and_public_key[0] }
  let(:public_key) { token_and_public_key[1] }

  before do
    user.update(public_key: public_key)
    request.headers['Authorization'] = token
  end

  describe '#authenticate' do
    context 'when the token is valid' do
      it 'sets the current user' do
        subject.authenticate
        expect(assigns(:current_user)).to eq(user)
      end
    end

    it 'raises a JWT::DecodeError when the token is invalid' do
      request.headers['Authorization'] = 'invalid_token'
      expect { subject.authenticate }.to raise_error(JWT::DecodeError)
    end

    it 'raises a JWT::DecodeError when user logged out, ' do
      user.update(public_key: nil)
      expect { subject.authenticate }.to raise_error(JWT::DecodeError)
    end
  end

  describe 'error handlers' do
    controller(Api::User::V1::BaseController) do
      def index_record_invalid
        user = User.new
        user.valid?
        raise ActiveRecord::RecordInvalid.new(user)
      end

      def index_record_not_found
        raise ActiveRecord::RecordNotFound.new('Not Found', User, :id, 1)
      end

      def index_decode_error
        raise JWT::DecodeError.new('Invalid token')
      end

      def index_expired_signature
        raise JWT::ExpiredSignature.new('Token has expired')
      end

      def index_verification_error
        raise JWT::VerificationError.new('Token verification failed')
      end

      def index_standard_error
        raise StandardError.new('An error occurred')
      end
    end

    before do
      routes.draw do
        get 'index_record_invalid' => 'api/user/v1/base#index_record_invalid'
        get 'index_record_not_found' => 'api/user/v1/base#index_record_not_found'
        get 'index_decode_error' => 'api/user/v1/base#index_decode_error'
        get 'index_expired_signature' => 'api/user/v1/base#index_expired_signature'
        get 'index_verification_error' => 'api/user/v1/base#index_verification_error'
        get 'index_standard_error' => 'api/user/v1/base#index_standard_error'
      end
    end

    it 'handles ActiveRecord::RecordInvalid' do
      get :index_record_invalid
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['message']).to eq("Password can't be blank. Email can't be blank. Email is invalid. Password can't be blank. Password is too short (minimum is 6 characters)")
    end

    it 'handles ActiveRecord::RecordNotFound' do
      get :index_record_not_found
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['message']).to eq('Not Found')
    end

    it 'handles JWT::DecodeError' do
      get :index_decode_error
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['message']).to eq('Invalid token')
    end

    it 'handles JWT::ExpiredSignature' do
      get :index_expired_signature
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['message']).to eq('Token has expired')
    end

    it 'handles JWT::VerificationError' do
      get :index_verification_error
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['message']).to eq('Token verification failed')
    end

    it 'handles StandardError' do
      get :index_standard_error
      expect(response).to have_http_status(:internal_server_error)
      expect(JSON.parse(response.body)['message']).to eq('An error occurred')
    end
  end
end
