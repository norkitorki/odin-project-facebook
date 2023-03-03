class UsersController < ApplicationController
  before_action :authenticate_user!, :set_user, :set_page

  def show
    posts  = @user.posts.includes(:comments, :likes, :user, :video, :images, :tag_list)
    @posts = resource_pagination(posts, @page, 20)
  end

  def comments
    @comments = resource_pagination(@user.comments.includes(:likes, :commentable), @page, 20)
  end

  def friends
    @friends = resource_pagination(@user.friends.includes(:image), @page, 60)
  end

  private

  def set_user
    @user = User.friendly.find(params[:id])
  end
end
