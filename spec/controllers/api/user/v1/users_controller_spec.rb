require 'rails_helper'

RSpec.describe Api::User::V1::UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:token_and_public_key) {
    res = Authentication.generate_token(user)
    user.update!(public_key: res[1])
    res
  }
  let(:token) { token_and_public_key[0] }
  let(:public_key) { token_and_public_key[1] }

  describe '#logout' do
    before do
      request.headers['Authorization'] = token
    end

    it 'logs out the user' do
      post :logout
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('Logged out successfully')
      expect(user.reload.public_key).to be_nil
    end
  end

  describe '#login' do
    let(:params) { { email: user.email, password: user.password } }

    it 'logs in the user' do
      post :login, params: params
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['data']).to include('id', 'email', 'token')
    end

    context 'when the password is incorrect' do
      let(:params) { { email: user.email, password: 'wrong_password' } }

      it 'returns unauthorized' do
        post :login, params: params
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['message']).to eq('Invalid email or password')
      end
    end

    context 'when the email is incorrect' do
      let(:params) { { email: "wrong_email", password: user.password } }

      it 'returns unauthorized' do
        post :login, params: params
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['message']).to eq('Invalid email or password')
      end
    end

    context 'when the email and password are incorrect' do
      let(:params) { { email: 'wrong_email', password: 'wrong_password' } }

      it 'returns unauthorized' do
        post :login, params: params
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['message']).to eq('Invalid email or password')
      end
    end
  end

  describe '#create' do
    context 'when the request is valid' do
      let(:params) { { email: 'test@example.com', password: 'password' } }

      it 'creates a new user' do
        expect { post :create, params: params }.to change { User.count }.by(1)
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['data']).to include('id', 'email')
      end
    end

    context 'when the password is less than 6 characters' do
      let(:params) { { email: 'test@example.com', password: 'pass' } }

      it 'returns an error' do
        post :create, params: params
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['message']).to include('Password is too short (minimum is 6 characters)')
      end
    end

    context 'when the email is already taken' do
      let(:params) { { email: user.email, password: 'password' } }

      it 'returns an error' do
        post :create, params: params
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['message']).to include('Email has already been taken')
      end
    end

    context 'when the password is empty' do
      let(:params) { { email: 'test@example.com', password: '' } }

      it 'returns an error' do
        post :create, params: params
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['message']).to include("Password can't be blank")
      end
    end

    context 'when the email is empty' do
      let(:params) { { email: '', password: 'password' } }

      it 'returns an error' do
        post :create, params: params
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['message']).to include("Email can't be blank")
      end
    end
  end
end
