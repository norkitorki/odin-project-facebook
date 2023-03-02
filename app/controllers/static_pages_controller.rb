class StaticPagesController < ApplicationController
  include PostsHelper

  before_action :authenticate_user!

  def home
    @post = Post.new
    @page = (params[:p] || 1).to_i
    @posts = resource_pagination(timeline_posts, @page, 16)
  end

  def discover
    @page = (params[:p] || 1).to_i
    users = User.all.includes(:image).order(:first_name)
    @users = resource_pagination(users, @page, 100)
  end
end
