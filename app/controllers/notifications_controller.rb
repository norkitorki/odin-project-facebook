class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, except: :index

  def index
    @notifications = current_user.notifications.order(created_at: :desc)
  end

  def show
    @notification.update(read: true)
    redirect_to (@notification.path || @notification.notifiable), status: :moved_permanently
  end

  def destroy
    @notification.destroy
    redirect_to notifications_path, alert: 'Notification has been deleted.'
  end

  private

  def set_notification
    @notification = Notification.friendly.find(params[:id])
  end

  def notification_params
    params.require(:notification).permit(:body)
  end
end
