class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, except: :index

  def index
    user_notifications = current_user.notifications.order(created_at: :desc)
    @notifications_by_date = notifications_by_date(user_notifications)
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

  def notifications_by_date(notifications)
    notifications.each_with_object({}) do |notification, hash|
      date = notification.created_at.strftime('%F')
      hash[date] ||= []
      hash[date] << notification
    end
  end
end
