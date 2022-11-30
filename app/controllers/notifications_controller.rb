class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: :show

  def index
    @notifications = user_notifications
  end

  def show
    @notification.destroy
    redirect_to (@notification.target_path || notifications_path), status: :moved_permanently
  end

  def destroy
    user_notifications.destroy_all
    redirect_to notifications_path, alert: 'Notifications have been cleared.'
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
  end

  def notification_params
    params.require(:notification).permit(:body)
  end

  def user_notifications
    current_user.notifications.unread
  end
end
