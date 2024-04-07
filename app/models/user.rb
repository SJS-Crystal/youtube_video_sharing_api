class User < ApplicationRecord
  before_save :set_default_name

  has_secure_password
  has_many :videos

  validates :email, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}
  validates :password, presence: true, length: {minimum: 6}, if: :password_validation_required?

  private

  def password_validation_required?
    new_record? || password.present?
  end

  def set_default_name
    self.name ||= email.split('@').first
  end
end
