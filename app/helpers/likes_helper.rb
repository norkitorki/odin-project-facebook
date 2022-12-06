module LikesHelper
  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end

  def find_or_initialize_like(user)
    Like.find_by(likeable_type: self.class.to_s, user_id: user.id) || Like.new
  end
end
