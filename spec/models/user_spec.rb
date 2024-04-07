require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(6) }
    it { should allow_value("user@example.com").for(:email) }
    it { should_not allow_value("userexample.com").for(:email) }
    it { should_not allow_value("123123ffdsf").for(:email) }
  end

  describe "associations" do
    it { should have_many(:videos) }
  end

  describe "password_validation_required" do
    it "returns true if it's a new record and password is not present" do
      user = User.new
      expect(user.send(:password_validation_required?)).to be true
    end

    it "returns true if it's a new record and password is present" do
      user = User.new(password: "password")
      expect(user.send(:password_validation_required?)).to be true
    end

    it "returns true if it's a persist record and password is present" do
      FactoryBot.create(:user)
      user = User.first
      user.password = "password"
      expect(user.send(:password_validation_required?)).to be true
    end

    it "returns false if it's a persist record and password is not present" do
      FactoryBot.create(:user)
      user = User.first
      expect(user.send(:password_validation_required?)).to be false
    end
  end
end
