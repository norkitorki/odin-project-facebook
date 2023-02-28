require 'rails_helper'

RSpec.describe Share, type: :model do
  fixtures :shares, :users

  before do
    @share = shares(:one)
  end

  it "should be valid with user and shareable" do
    share = @share.dup
    @share.destroy!
    expect(share).to be_valid
  end

  it "should validate share uniqueness" do
    expect(@share).to_not be_valid
    expect(@share.errors.full_messages).to include('User has already received share')
  end

  it "should validate user validity" do
    @share.shareable.user = @share.user
    expect(@share).to_not be_valid
    expect(@share.errors.full_messages).to include('User cannot share to themselves')
  end

  it "should create notification after save" do
    share = @share.dup
    @share.destroy
    expect { share.save! }.to change { Notification.count }.by(1)
    expect(Notification.find_by(user: share.user, body: 'Jane Doe has shared a Post with you.')).to be_present
  end
end
