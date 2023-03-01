class StaticPagesController < ApplicationController
  include PostsHelper

  before_action :authenticate_user!

  def home
    @post = Post.new
    @page = (params[:p] || 1).to_i
    @posts = resource_pagination(timeline_posts, @page, 16)
  end

  def discover
    @users = User.all.includes(:image).shuffle
  end
end
