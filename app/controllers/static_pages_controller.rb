class StaticPagesController < ApplicationController
  include PostsHelper

  before_action :authenticate_user!

  def home
    @post = Post.new
    @page = (params[:page] || 1).to_i
    @timeline = timeline_posts.order(updated_at: :desc).offset((@page - 1) * 16).limit(16)
  end

  def discover
    @users = User.all.includes(:image).shuffle
  end
end
