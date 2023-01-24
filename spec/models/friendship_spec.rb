require 'rails_helper'

RSpec.describe Friendship, type: :model do
  fixtures 'users'

  before do
    @friendship = subject.class.new(user: users(:one), friend: users(:two))
  end

  it "should be valid with distinct user and friend" do
    expect(@friendship).to be_valid
  end

  it "should be invalid when user is friend" do
    @friendship.friend = @friendship.user
    expect(@friendship).to_not be_valid
  end

  it "should be invalid without a friend" do
    @friendship.friend = nil
    expect(@friendship).to_not be_valid
  end

  it "should be invalid without a user" do
    @friendship.user = nil
    expect(@friendship).to_not be_valid
  end

  it "should create inverse record after creation" do
    expect { @friendship.save! }.to change { subject.class.count }.by(2)

    inverse_friendship = subject.class.find_by(user: @friendship.friend, friend: @friendship.user)
    expect(inverse_friendship).to_not be_nil
  end

  it "should delete inverse record after deletion" do
    @friendship.save!
    expect { @friendship.destroy }.to change { subject.class.count }.by(-2)
  end

  it "should not save when record already exists" do
    @friendship.save!
    friendship_copy = @friendship.dup
    expect(friendship_copy).to_not be_valid
  end
end
