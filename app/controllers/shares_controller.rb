class SharesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_share, only: %i[ show destroy ]
  before_action :authorize_user, only: %i[ show destroy ]

  def index
    @shares = current_user.shares.includes(:shareable)
  end

  def show
    redirect_to @share.shareable, status: :see_other
  end

  def new
    @shareable_type = params[:shareable][:shareable_type]
    @shareable_id   = params[:shareable][:shareable_id]
    @share          = Share.new(shareable_type: @shareable_type, shareable_id: @shareable_id)
    @shareable      = @share.shareable
    authorize_user(@shareable.user)
    @users = eligible_users(@shareable)
  end

  def create
    @share     = Share.new(share_params[:shareable])
    @shareable = @share.shareable
    @user_ids  = share_params[:users] || []

    return redirect_to new_share_path(shareable: share_params[:shareable]),
      alert: 'No user has been selected.' if @user_ids.empty?

    create_shares_for_users
    redirect_to @share.shareable,
      notice: "#{@shareable.class} has been shared." if @user_ids.any?
  end

  def destroy
    @share.destroy
    redirect_to shares_path, alert: 'Share has been successfully deleted.'
  end

  private

  def set_share
    @share = Share.friendly.find(params[:id])
  end

  def authorize_user(user = @share.user)
    (redirect_to @share.shareable,
      alert: 'You are not allowed to perform this action',
      status: :forbidden
    ) unless user == current_user
  end

  def share_params
    params.require(:share).permit(shareable: {}, users: [])
  end

  def eligible_users(shareable)
    current_user.friends.reject do |user|
      Share.exists?(user: user, shareable: shareable) || shareable.user == user
    end
  end

  def create_shares_for_users
    @user_ids.each do |id|
      user = User.friendly.find(id)
      share = @share.dup
      share.user_id = user.id
      share.save
    end
  end
end
