require 'rails_helper'

RSpec.describe Notification, type: :model do
  fixtures :notifications, :friend_requests

  before do
   @notification = notifications(:one)
  end

  it "should be valid with a body,path,user and notifiable" do
    expect(@notification).to be_valid
  end

  it "should be valid without path" do
    @notification.path = nil
    expect(@notification).to be_valid
  end

  it "should be invalid without body" do
    @notification.body = nil
    expect(@notification).to_not be_valid
  end

  it "should be invalid without user" do
    @notification.user = nil
    expect(@notification).to_not be_valid
  end

  it "should be invalid without notifiable" do
    @notification.notifiable = nil
    expect(@notification).to_not be_valid
  end

  it "should be invalid when body is over 100 characters long" do
    @notification.body = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
    expect(@notification).to_not be_valid
  end

  it "should return unread notifications" do
    expect(Notification.unread).to include(@notification)
    @notification.update(read: true)
    expect(Notification.unread).to be_empty
  end
end
