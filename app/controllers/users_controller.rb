class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def show
    @posts    = @user.posts.includes(:comments, :likes, :user)
    @comments = @user.comments.includes(:likes, :user)
    @friends  = @user.friends
  end

  def activity
    @activity = user_activity(@user.posts, @user.comments)
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

  def set_user
    @user = User.friendly.find(params[:id])
  end

  def user_activity(*resources)
    resources.flatten.sort { |a, b| b.updated_at <=> a.updated_at }.last(12)
  end
end
