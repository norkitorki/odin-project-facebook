require 'rails_helper'

RSpec.describe "Notifications", type: :system do
  include Devise::Test::IntegrationHelpers

  fixtures :users, :notifications

  before do
    driven_by(:rack_test)
    sign_in @user = users(:one)
    visit root_path
  end

  it "should view all notifications" do
    click_on 'Notifications'

    expect(page).to have_current_path(notifications_path)
  end

  it "should view notification" do
    click_on 'Notifications'

    notification = notifications(:two)

    within("#notification_#{notification.slug}") do
      click_on notification.body
    end

    expect(page).to have_current_path(post_path(notification.notifiable))
  end

  it "should view notification from navigation bar" do
    notification = notifications(:two)

    within('#notifications') do
      click_on notification.body
    end

    expect(page).to have_current_path(post_path(notification.notifiable))
  end

  it "should delete notification" do
    click_on 'Notifications'

    notification = notifications(:one)

    expect { within("#notification_#{notification.slug}") { click_button 'notification-delete' } }.to change { @user.notifications.count }.by(-1)
    expect(page).to have_current_path(notifications_path)
  end

  it "should delete all notifications" do
    expect { within('#notifications') { click_on 'Clear All' } }.to change { Notification.count }.by(-2)
  end
end
