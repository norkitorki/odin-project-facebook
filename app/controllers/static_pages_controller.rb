class StaticPagesController < ApplicationController
  include PostsHelper

  before_action :authenticate_user!, :set_page

  def home
    @post = Post.new
    @posts = resource_pagination(timeline_posts, @page, 16)
  end

  def discover
    users = User.all.includes(:image).order(:first_name)
    @users = resource_pagination(users, @page, 100)
  end
end
