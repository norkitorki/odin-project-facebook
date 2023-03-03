class ApplicationController < ActionController::Base
  before_action :set_notifications, if: :user_signed_in?

  private

  def set_notifications
    @notifications = current_user.notifications.unread.order(created_at: :desc)
  end

  def set_page
    @page = (params[:p] || 1).to_i
  end

  def resource_pagination(resources, page, max_count)
    resources.order(updated_at: :desc).offset((page - 1) * max_count).limit(max_count)
  end
end
