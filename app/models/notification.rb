class Notification < ApplicationRecord
  scope :unread, -> { where(read: false).order(created_at: :desc) }

  belongs_to :user

  validates :body, presence: true, length: { maximum: 100 }
end
