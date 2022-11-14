class Friendship < ApplicationRecord
  after_create :create_inverse, 
    unless: [ :inverse_exists?, :inverse_is_user? ]
  after_destroy :destroy_inverse, 
    if: :inverse_exists?

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

  def inverse_is_user?
    user == friend
  end

  def inverse_options
    { user_id: friend_id, friend_id: user_id }
  end
end
