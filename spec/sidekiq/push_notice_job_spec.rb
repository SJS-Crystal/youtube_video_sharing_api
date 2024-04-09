require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.inline!

RSpec.describe PushNoticeJob, type: :job do
  describe "#perform" do
    let(:share_user_id) { 1 }
    let(:shared_by) { "John Doe" }
    let(:youtube_id) { "abc123" }
    let(:title) { "Test Video" }
    let(:user_ids) { [1, 2, 3, 4] }

    before do
      allow(User).to receive(:pluck).and_return(user_ids)
      allow(ActionCable.server).to receive(:broadcast)
    end

    it "broadcasts a message to all users except the share_user_id" do
      user_ids.each do |user_id|
        if user_id == share_user_id
          expect(ActionCable.server).not_to receive(:broadcast).with("notification_channel_#{user_id}", {
            shared_by: shared_by, youtube_id: youtube_id, title: title
          })
        else
          expect(ActionCable.server).to receive(:broadcast).with("notification_channel_#{user_id}", {
            shared_by: shared_by, youtube_id: youtube_id, title: title
          })
        end
      end

      PushNoticeJob.perform_async(share_user_id, shared_by, youtube_id, title)
    end
  end
end
