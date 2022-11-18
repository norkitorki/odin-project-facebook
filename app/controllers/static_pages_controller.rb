class StaticPagesController < ApplicationController
  before_action :authenticate_user!

  def home
    ids = current_user.friends.ids << current_user.id
    @posts = Post.where(user_id: ids).includes(:comments, :likes, :user).order(updated_at: :desc)
  end
end
