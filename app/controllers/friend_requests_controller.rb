class FriendRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_friend_request, only: %i[ show destroy ]

  def index
    @friend_requests = current_user.pending_friend_requests.includes(:user)
  end

  def show
  end

  def new
    if @friend_request = FriendRequest.find_by(candidate: current_user)
      redirect_to @friend_request, alert: 'User already wants to be your friend.', status: :see_other
    else
      @friend_request = current_user.friend_requests.new
      @candidate = User.find(params[:candidate])
    end
  end

  def create
    @friend_request = current_user.friend_requests.new(friend_request_params)
    
    if @friend_request.save
      redirect_to root_path, notice: 'Friend request has been sent.'
    else
      flash.now[:alert] = 'Friend request has not been sent.'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @friend_request.destroy

    if params[:commit] == 'Accept'
      current_user.friendships.create(friend: @friend_request.user)
      notice = 'You have accepted the friend request.'
    else
      notice = 'You have declined the friend request.'
    end
    redirect_to friend_requests_path, notice: notice
  end

  private

  def friend_request_params
    params.require(:friend_request).permit(:message, :candidate_id)
  end

  def set_friend_request
    @friend_request = FriendRequest.find(params[:id])
  end
end
