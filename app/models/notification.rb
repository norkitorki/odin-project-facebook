class Notification < ApplicationRecord
  scope :unread, -> { where(read: false).order(created_at: :desc) }

  def self.add(body:, user:, target_path: nil)
    @notification = Notification.create(body: body, user: user, target_path: target_path)
    ActionCable.server.broadcast('notification', @notification)
  end

  belongs_to :user

  validates :body, presence: true, length: { maximum: 100 }
end
