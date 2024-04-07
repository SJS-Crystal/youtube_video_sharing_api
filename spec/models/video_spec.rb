require 'rails_helper'

RSpec.describe Video, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:youtube_id) }
  end

  describe "associations" do
    it { should belong_to(:user) }
  end
end
