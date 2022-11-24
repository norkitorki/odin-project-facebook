module LikesHelper
  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end

  def find_or_initialize_like(user)
    likes.find_or_initialize_by(user_id: user.id)
  end
end
