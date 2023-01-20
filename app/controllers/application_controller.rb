class ApplicationController < ActionController::Base
  before_action :set_notifications, if: :user_signed_in?

  private

  def set_notifications
    @notifications = current_user.notifications.unread.order(created_at: :desc)
  end
end
