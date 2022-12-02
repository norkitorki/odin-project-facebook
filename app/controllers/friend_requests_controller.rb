class FriendRequestsController < ApplicationController
  before_action :authenticate_user!
  def index
    @friend_requests = current_user.pending_friend_requests.includes(:user)
  end

  def show
  end

  def new
    @friend_request = current_user.friend_requests.new
    @candidate = User.find(params[:candidate])
  end

  def create
    @friend_request = current_user.friend_requests.new(friend_request_params)
    
    if @friend_request.save
      redirect_to root_path, notice: 'Friend Request has been send.'
    else
      flash.now[:alert] = 'Friend request has not been send.'
      render :new, status: :unprocessable_entity
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
    params.require(:friend_request).permit(:message, :candidate_id)
  end
end
