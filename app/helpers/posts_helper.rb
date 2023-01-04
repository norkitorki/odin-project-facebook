module PostsHelper
  private

  def timeline_posts
    user_ids = current_user.friends.ids << current_user.id
    Post.where(user_id: user_ids).includes(:comments, :images, :likes, :links, :user)
  end
end
