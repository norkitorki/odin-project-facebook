class StaticPagesController < ApplicationController
  include PostsHelper

  before_action :authenticate_user!

  def home
    @friend_requests = current_user.pending_friend_requests
    @post = Post.new
    @posts = timeline_posts
    @timeline = (@friend_requests + @posts).sort { |a, b| b.updated_at <=> a.updated_at }
  end

  def discover
    
  end
end
