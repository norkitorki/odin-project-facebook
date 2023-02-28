require 'pry'

class Share < ApplicationRecord
  after_save :notify_user

  extend FriendlyId

  include ApplicationHelper

  friendly_id :generate_uuid, use: :slugged

  validate :share_uniqueness, :user_validity

  belongs_to :user
  belongs_to :shareable, polymorphic: true

  has_one :notification, as: :notifiable,
    dependent: :destroy

  private

  def share_exists?
    self.class.exists?(user: user, shareable: shareable)
  end

  def share_uniqueness
    errors.add(:user, 'has already received share') if share_exists?
  end

  def user_validity
    errors.add(:user, 'cannot share to themselves') if user == shareable.user
  end

  def notify_user
    shareable_user_name = shareable.user.full_name
    create_notification(user: user, body: "#{shareable_user_name} has shared a #{shareable_type} with you.")
  end
end
