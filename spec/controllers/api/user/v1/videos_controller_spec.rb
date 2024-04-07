require 'rails_helper'

RSpec.describe Api::User::V1::VideosController, type: :controller do
  let(:user) { create(:user) }
  let(:token_and_public_key) { Authentication.generate_token(user) }
  let(:token) { token_and_public_key[0] }
  let(:public_key) { token_and_public_key[1] }

  describe '#create' do
    before do
      user.update!(public_key: public_key)
      request.headers['Authorization'] = token
    end

    context 'when the url is valid' do
      let(:params) { { url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ' } }
      let(:video_info) { { youtube_id: 'test123', title: 'Rick Astley - Never Gonna Give You Up', description: 'test description' } }

      before do
        allow(Youtube).to receive(:get_video_info).and_return(video_info)
      end

      it 'creates a new video' do
        expect(response).to have_http_status(200)
        expect { post :create, params: params }.to change { user.videos.count }.by(1)
      end
    end

    context 'when the url is invalid' do
      let(:params) { { url: 'https://www.invalidurl.com' } }

      before do
        allow(Youtube).to receive(:get_video_info).and_return(nil)
      end

      it 'returns a bad request status' do
        post :create, params: params
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['message']).to eq('Invalid youtube url')
      end
    end
  end
end