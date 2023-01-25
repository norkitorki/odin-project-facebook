class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  validate :user_validity

  private

  def user_validity
    case
    when user && likeable && likeable.user == user
      errors.add(:user_id, "cannot like their own #{likeable.class}")
    when Like.exists?(user: user, likeable: likeable)
      errors.add(:user_id, "has already liked this #{likeable.class}")
    end
  end
end
