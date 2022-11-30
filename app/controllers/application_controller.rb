class ApplicationController < ActionController::Base
  before_action :set_notifications

  private

  def set_notifications
    @notifications = current_user.notifications.order(created_at: :desc) if user_signed_in?
  end
end
