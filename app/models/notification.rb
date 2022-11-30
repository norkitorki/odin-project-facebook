class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  validates :body, presence: true, length: { maximum: 100 }
end
