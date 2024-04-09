require 'rails_helper'

RSpec.describe Api::User::V1::VideosController, type: :controller do
  let(:user) { create(:user) }
  let(:token_and_public_key) {
    res = Authentication.generate_token(user)
    user.update!(public_key: res[1])
    res
  }
  let(:token) { token_and_public_key[0] }
  let(:public_key) { token_and_public_key[1] }

  describe '#create' do
    before do
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

  describe '#index' do
    it 'returns list videos' do
      videos = create_list(:video, 9, user: user)

      get :index, params: { page: 1, items: 5 }

      expect(response.status).to eq 200
      parsed_response = JSON.parse(response.body)

      expect(parsed_response['data'].size).to eq 5

      returned_ids = parsed_response['data'].map { |video| video['id'] }
      expect(returned_ids).to match_array(videos.map(&:id).last(5))

      parsed_response['data'].each do |video|
        expect(video['id']).to be_present
        expect(video['shared_by']).to be_present
        expect(video['title']).to be_present
        expect(video['description']).to be_present
        expect(video['youtube_id']).to be_present
      end
    end
  end
end
