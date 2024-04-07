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
      def action_that_raises_record_invalid
        user = User.new
        user.valid?
        raise ActiveRecord::RecordInvalid.new(user)
      end

      def action_that_raises_record_not_found
        raise ActiveRecord::RecordNotFound.new('Not Found', User, :id, 1)
      end

      def action_that_raises_decode_error
        raise JWT::DecodeError.new('Invalid token')
      end

      def action_that_raises_expired_signature
        raise JWT::ExpiredSignature.new('Token has expired')
      end

      def action_that_raises_verification_error
        raise JWT::VerificationError.new('Token verification failed')
      end

      def action_that_raises_standard_error
        raise StandardError.new('An error occurred')
      end

      def action_that_raises_variable_error
        raise Pagy::VariableError.new("dummy message", 1, 2, 3)
      end
    end

    before do
      routes.draw do
        get 'action_that_raises_record_invalid' => 'api/user/v1/base#action_that_raises_record_invalid'
        get 'action_that_raises_record_not_found' => 'api/user/v1/base#action_that_raises_record_not_found'
        get 'action_that_raises_decode_error' => 'api/user/v1/base#action_that_raises_decode_error'
        get 'action_that_raises_expired_signature' => 'api/user/v1/base#action_that_raises_expired_signature'
        get 'action_that_raises_verification_error' => 'api/user/v1/base#action_that_raises_verification_error'
        get 'action_that_raises_standard_error' => 'api/user/v1/base#action_that_raises_standard_error'
        get 'action_that_raises_variable_error' => 'api/user/v1/base#action_that_raises_variable_error'
      end
    end

    it 'handles ActiveRecord::RecordInvalid' do
      get :action_that_raises_record_invalid
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['message']).to eq("Password can't be blank. Email can't be blank. Email is invalid. Password is too short (minimum is 6 characters)")
    end

    it 'handles ActiveRecord::RecordNotFound' do
      get :action_that_raises_record_not_found
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['message']).to eq('Not Found')
    end

    it 'handles JWT::DecodeError' do
      get :action_that_raises_decode_error
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['message']).to eq('Invalid token')
    end

    it 'handles JWT::ExpiredSignature' do
      get :action_that_raises_expired_signature
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['message']).to eq('Token has expired')
    end

    it 'handles JWT::VerificationError' do
      get :action_that_raises_verification_error
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['message']).to eq('Token verification failed')
    end

    it 'handles StandardError' do
      get :action_that_raises_standard_error
      expect(response).to have_http_status(:internal_server_error)
      expect(JSON.parse(response.body)['message']).to eq('An error occurred')
    end

    it 'handles Pagy VariableError' do
      get :action_that_raises_variable_error
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['message']).to eq('expected :1 2; got 3')
    end
  end

  describe '#pagy_metadata' do
    controller(Api::User::V1::BaseController) do
      def pagy_metadata_test
        @pagy, videos = pagy(Video.all, items: 1)
        render json: {data: videos, page_metadata: pagy_metadata(@pagy).to_json}
      end
    end

    before do
      routes.draw {
        get 'pagy_metadata_test' => 'api/user/v1/base#pagy_metadata_test'
      }
    end

    it 'returns the correct pagy metadata' do
      Video.delete_all
      create_list(:video, 20)

      get :pagy_metadata_test

      metadata = JSON.parse(response.body)['page_metadata']
      expect(response.status).to eq 200
      expect(metadata).to eq({
        "current_page" => 1,
        "next_page" => 2,
        "prev_page" => nil,
        "total_pages" => 20,
        "total_count" => 20
      }.to_json)
    end
  end
end
