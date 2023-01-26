require 'rails_helper'

RSpec.describe FriendRequest, type: :model do
  fixtures :users

  before do
    @friend_request = subject.class.new(user: users(:three), candidate: users(:four), message: 'test')
  end

  it "should be valid without a message" do
    @friend_request.message = nil
    expect(@friend_request).to be_valid
  end

  it "should be invalid without a user" do
    @friend_request.user = nil
    expect(@friend_request).to_not be_valid
  end

  it "should be invalid without a candidate" do
    @friend_request.candidate = nil
    expect(@friend_request).to_not be_valid
  end

  it "should create notification after save" do
    expect { @friend_request.save! }.to change { Notification.count }.by(1)
  end

  it "should delete inverse requests after deletion" do
    inverse_friend_request = subject.class.new(user: @friend_request.candidate, candidate: @friend_request.user, message: 'testing deletion of inverse requests')
    @friend_request.save! && inverse_friend_request.save!
    expect { inverse_friend_request.destroy! }.to change { subject.class.count }.by(-2)
  end

  it "should not save when user and candidate are equal" do
    @friend_request.candidate = @friend_request.user
    expect(@friend_request).to_not be_valid
  end

  it "should not save when record already exists" do
    @friend_request.save!
    friend_request_copy = @friend_request.dup
    expect(friend_request_copy).to_not be_valid
  end
end
