require 'rails_helper'

RSpec.describe NotificationChannel, type: :channel do
  let(:user) { create(:user) }

  before do
    stub_connection current_user: user
    subscribe
  end

  it 'subscribes to the correct stream' do
    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("notification_channel_#{user.id}")
  end

  it 'unsubscribes successfully' do
    unsubscribe

    expect(subscription.streams).to be_empty
  end
end
