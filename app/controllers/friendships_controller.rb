class FriendshipsController < ApplicationController
  before_action :authenticate_user!, :set_friendship

  def destroy
    @friendship.destroy
    redirect_to @friendship.user, alert: 'Friend has been removed.'
  end

  private

  def set_friendship
    @friendship = Friendship.find_by(user_id: params[:user_id], friend_id: params[:friend_id])
  end
end
