class Notification < ApplicationRecord
  extend FriendlyId
  
  include ApplicationHelper

  friendly_id :generate_uuid, use: :slugged

  scope :unread, -> { where(read: false) }

  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  validates :body, presence: true, length: { maximum: 100 }
end
