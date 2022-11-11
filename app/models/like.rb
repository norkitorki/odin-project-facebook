class Like < ApplicationRecord
  before_validation :validate_user

  belongs_to :user
  belongs_to :likeable, polymorphic: true

  private

  def validate_user
    case  
    when user && likeable.user == user
      errors.add(:user_id, "cannot like their own #{likeable.class}")
    when Like.find_by(user: user, likeable: likeable)
      errors.add(:user_id, "has already liked this #{likeable.class}")
    end
  end
end
