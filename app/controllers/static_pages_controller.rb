class StaticPagesController < ApplicationController
  before_action :authenticate_user!

  def home
    @posts = (current_user.posts + current_user.friends.includes(:posts).map(&:posts).to_a.flatten).sort_by { |p| p.updated_at }.reverse
  end
end
