require 'rails_helper'

RSpec.describe FriendRequest, type: :model do
  fixtures :users

  before do
    @friend_request = FriendRequest.new(user: users(:one), candidate: users(:two), message: 'test')
  end

  it "should create notification after save" do
    expect { @friend_request.save! }.to change { Notification.count }.by(1)
  end

  it "should delete inverse requests after deletion" do
    inverse_friend_request = FriendRequest.new(user: @friend_request.candidate, candidate: @friend_request.user, message: 'testing deletion of inverse requests')
    @friend_request.save! && inverse_friend_request.save!
    expect { inverse_friend_request.destroy! }.to change { FriendRequest.count }.by(-2)
  end

  it "should not save when user and candidate are equal" do
    @friend_request.candidate = @friend_request.user
    expect { @friend_request.save! }.to raise_exception(ActiveRecord::RecordInvalid)
  end

  it "should not save when record already exists" do
    @friend_request.save!
    expect { @friend_request.dup.save! }.to raise_exception(ActiveRecord::RecordInvalid)
  end
end
