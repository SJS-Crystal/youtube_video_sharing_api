require "rails_helper"
require "net/http"

RSpec.describe Youtube do
  describe ".get_video_info" do
    let(:youtube_id) { SecureRandom.alphanumeric(11) }
    let(:api_url) { "https://www.googleapis.com/youtube/v3/videos?id=#{youtube_id}&key=#{ENV["YOUTUBE_API_KEY"]}&part=snippet" }
    let(:response_body) { '{"items":[{"snippet":{"title":"Video Title","description":"Video Description"}}]}' }

    before do
      allow(Net::HTTP).to receive(:get).with(URI(api_url)).and_return(response_body)
    end

    context "when given a valid YouTube URL" do
      let(:url) { "https://www.youtube.com/watch?v=#{youtube_id}" }

      it "returns the video information" do
        video_info = Youtube.get_video_info(url)
        expect(video_info).to eq({ youtube_id: youtube_id, title: "Video Title", description: "Video Description" })
      end
    end

    context "when given an invalid YouTube URL" do
      let(:url) { "https://www.example.com" }

      it "returns nil" do
        video_info = Youtube.get_video_info(url)
        expect(video_info).to be_nil
      end
    end

    context "when the YouTube API response is empty" do
      let(:url) { "https://www.youtube.com/watch?v=#{youtube_id}" }
      let(:response_body) { '{"items":[]}' }

      it "returns nil" do
        video_info = Youtube.get_video_info(url)
        expect(video_info).to be_nil
      end
    end
  end
end
