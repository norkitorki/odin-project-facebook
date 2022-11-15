class StaticPagesController < ApplicationController
  before_action :authenticate_user!

  def home
    @users = User.all
    @friend_request = current_user.friend_requests.new
  end
end
