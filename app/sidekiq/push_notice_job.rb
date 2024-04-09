class PushNoticeJob
  include Sidekiq::Job

  sidekiq_options retry: 1

  def perform(share_user_id, shared_by, youtube_id, title)
    message = {shared_by: shared_by, youtube_id: youtube_id, title: title}
    User.pluck(:id).each do |user_id|
      next if user_id == share_user_id

      ActionCable.server.broadcast("notification_channel_#{user_id}", message)
    end
  end
end
