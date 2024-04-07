class Video < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :youtube_id, presence: true
end
