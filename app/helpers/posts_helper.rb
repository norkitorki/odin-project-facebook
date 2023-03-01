module PostsHelper
  private

  def timeline_posts
    user_ids = current_user.friends.ids << current_user.id
    Post.where(user_id: user_ids).includes(preloaded_resources)
  end

  def preloaded_resources
    [:comments, :images, :likes, :links, :tag_list, :user, :video]
  end
end
