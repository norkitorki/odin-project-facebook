class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def show
    @posts = resource_pagination(posts, @page, 20)
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
    resources.flatten.sort { |a, b| b.created_at <=> a.created_at }.last(12)
  end
end
