class Notification < ApplicationRecord
  scope :unread, -> { where(read: false) }

  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  validates :body, presence: true, length: { maximum: 100 }
end
