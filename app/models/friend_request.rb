class FriendRequest < ApplicationRecord
  after_destroy :destroy_inverse_requests, if: :inverse_request_exists?

  validate :user_is_not_candidate, :pending_requests

  belongs_to :user
  belongs_to :candidate, class_name: 'User'

  has_many :notifications, as: :notifiable,
    dependent: :destroy

  private

  def destroy_inverse_requests
    self.class.where(user: candidate, candidate: user).destroy_all
  end

  def user_is_not_candidate
    errors.add(:user, 'cannot send friend request to themselves') if user == candidate
  end

  def pending_requests
    errors.add(:user, 'cannot send multiple friend requests') if request_exists?
  end

  def request_exists?
    self.class.exists?(user: user, candidate: candidate)
  end

  def inverse_request_exists?
    self.class.exists?(user: candidate, candidate: user)
  end
end
