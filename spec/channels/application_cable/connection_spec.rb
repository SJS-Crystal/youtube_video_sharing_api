require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  let(:user) { create(:user) }
  let(:token_and_public_key) {
    res = Authentication.generate_token(user)
    user.update!(public_key: res[1])
    res
  }
  let(:token) { token_and_public_key[0] }
  let(:public_key) { token_and_public_key[1] }

  it "successfully connects" do
    connect "/cable", params: { token: token }
    expect(connection.current_user).to eq user
  end

  it "rejects connection with requests without token" do
    expect { connect "/cable" }.to have_rejected_connection
  end

  it "rejects connection with requests without token" do
    expect { connect "/cable", params: { token: 'non_exist_token' } }.to have_rejected_connection
  end
end
