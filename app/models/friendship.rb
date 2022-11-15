class Friendship < ApplicationRecord
  after_create :create_inverse, unless: :inverse_exists?
  after_destroy :destroy_inverse, if: :inverse_exists?

  validate :friendship_existence, :inverse_is_not_user

  belongs_to :user
  belongs_to :friend, class_name: 'User'

  private

  def create_inverse
    self.class.create(inverse_options)
  end

  def destroy_inverse
    self.class.where(inverse_options).destroy_all
  end

  def inverse_exists?
    self.class.exists?(inverse_options)
  end

  def inverse_options
    { user_id: friend_id, friend_id: user_id }
  end

  def friendship_existence
    errors.add(:friend, 'already exists') if friendship_exists?
  end

  def friendship_exists?
    self.class.exists?(user: user, friend: friend)
  end

  def inverse_is_not_user
    errors.add(:friend, 'cannot be user') if user == friend
  end
end
