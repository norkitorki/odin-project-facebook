require 'rails_helper'

RSpec.describe User, type: :model do
  fixtures :users

  before do
    @user = users(:one)
  end

  it "should be valid with email,first_name,last_name,gender and birthday" do
    expect(@user).to be_valid
  end

  it "should be valid without gender" do
    @user.gender = nil
    expect(@user).to be_valid
  end

  it "should be invalid without email" do
    @user.email = nil
    expect(@user).to_not be_valid
  end

  it "should be invalid without first_name" do
    @user.first_name = nil
    expect(@user).to_not be_valid
  end

  it "should be invalid without last_name" do
    @user.last_name = nil
    expect(@user).to_not be_valid
  end

  it "should be invalid without birthday" do
    @user.birthday = nil
    expect(@user).to_not be_valid
  end

  it "should be invalid when email is not unique" do
    user = users(:two)
    user.email = @user.email
    expect(user).to_not be_valid
  end

  it "should be invalid when email is of invalid format" do
    @user.email = 'john.doe@'
    expect(@user).to_not be_valid
  end

  describe "slug" do
    before do
      @user_copy = users(:two).dup
      @user_copy.email = 'test@testing.com'
      @user_copy.password = '********'
    end

    context "when name is unique" do
      it "should generate slug from name when saved" do
        @user_copy.first_name = 'Miss'
        expect { @user_copy.save! }.to change { @user_copy.slug }.to eq('miss_doe')
      end
    end

    context "when name is not unique" do
      it "should generate slug from name appended by a uuid" do
        user = @user_copy.dup
        user.email = 'testing@testing.com'
        user.password = '***********'
        [@user_copy, user].each(&:save!)
        expect(user.slug).to match(/jane_doe-[a-f0-9-]{36}/)
      end
    end
  end

  describe '#full_name' do
    it "should return the full name" do
      expect(@user.full_name).to eq('John Doe')
    end
  end

  describe '#friend?' do
    let(:other_user) { users(:two) }

    it "should return true when users are friends" do
      @user.friends << other_user
      expect(@user.friend?(other_user)).to be true
    end

    it "should return false when users are not friends" do
      expect(@user.friend?(other_user)).to be false
    end
  end

  describe '#friend_request?' do
    fixtures :friend_requests

    let(:other_user) { users(:two) }

    it "should return true when friend request exists" do
      expect(@user.friend_request?(other_user)).to be true
    end

    it "should return false when no friend request exists" do
      @user.friend_requests.destroy_all
      expect(@user.friend_request?(other_user)).to be false
    end
  end

  describe '#photo' do
    fixtures :images

    it "should return image if it exists" do
      expect(@user.photo).to eq(images(:one))
    end

    it "should return gravatar_url without image" do
      @user.image = nil
      expect(@user.photo).to eq(@user.gravatar_url)
    end

    it "should return gravatar_url if image exists with no assigned photo" do
      @user.image.photo = nil
      @user.image.remote_photo = nil
      expect(@user.photo).to eq(@user.gravatar_url)
    end
  end
end
