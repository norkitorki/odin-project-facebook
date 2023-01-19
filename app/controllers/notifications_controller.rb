class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: :show

  def index
    @notifications = current_user.notifications.order(created_at: :desc)
  end

  def show
    @notification.update(read: true)
    redirect_to (@notification.path || @notification.notifiable), status: :moved_permanently
  end

  def destroy
    current_user.notifications.destroy_all
    redirect_to notifications_path, alert: 'Notifications have been cleared.'
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
  end

  def notification_params
    params.require(:notification).permit(:body)
  end
end
