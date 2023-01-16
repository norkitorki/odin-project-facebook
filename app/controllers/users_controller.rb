class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user     = User.friendly.find(params[:id])
    @posts    = @user.posts.includes(:comments, :likes, :user)
    @comments = @user.comments.includes(:likes, :user)
    @activity = user_activity(@posts, @comments)
  end

  def posts
    @posts = @user.posts.includes(:comments, :likes, :user)
  end

  def comments
    @comments = Comment.where(user_id: @user.id).includes(:likes)
  end

  def friends
    @friends = @user.friends.includes(:image)
  end

  private

  def user_activity(*resources)
    resources.flatten.sort { |a, b| b.updated_at <=> a.updated_at }.last(12)
  end
end
