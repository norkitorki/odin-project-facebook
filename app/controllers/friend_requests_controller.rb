class FriendRequestsController < ApplicationController
  def index
    @friend_requests = current_user.pending_friend_requests.includes(:user)
  end

  def new
    @friend_request = current_user.friend_requests.new
    @candidate = User.find(params[:candidate])
  end

  def create
    @friend_request = current_user.friend_requests.new(friend_request_params)
    
    if @friend_request.save
      flash.now[:notice] = 'Friend request has been send'
    else
      flash.now[:alert] = 'Friend request has not been send'
    end
  end

  def destroy
    @friend_request = current_user.pending_friend_requests.find_by(friend_request_params)

    if params[:commit] == 'Accept'
      current_user.friendships.create(friend: @friend_request.user)
    end
    @friend_request.destroy
  end

  private

  def friend_request_params
    params.require(:friend_request).permit(:candidate_id)
  end
end
