require 'rails_helper'

RSpec.describe "FriendRequests", type: :system do
  include Devise::Test::IntegrationHelpers

  fixtures :users

  before do
    driven_by(:rack_test)
    sign_in @user = users(:one)
  end

  it "should view pending friend requests" do
    visit root_path

    click_on 'Friend Requests'

    expect(page).to have_current_path(friend_requests_path)
  end

  it "should send friend request through user profile" do
    FriendRequest.destroy_all
    visit user_path(user_2 = users(:two))

    within('.menu-list') do
      click_on 'Send Friend Request'
    end

    expect(page).to have_current_path(new_friend_request_path(candidate_id: user_2.slug))
    expect { click_on 'Send' }.to change { @user.friend_requests.count }.by(1)
  end

  it "should send friend request through user post" do
    sign_in user = users(:three)

    visit user_path(@user)

    within "#post_#{@user.posts.first.slug}" do
      click_on(class: 'post-friend-request')
    end

    expect(page).to have_current_path(new_friend_request_path(candidate_id: @user.slug))
    expect { click_on 'Send' }.to change { user.friend_requests.count }.by(1)
  end

  context "when user has recevied friend request" do
    before do
      sign_in users(:two)
      visit root_path

      click_on 'Friend Requests'

      expect(page).to have_current_path(friend_requests_path)
    end

    it "should accept friend request" do
      expect { click_on 'Accept' }.to change { @user.friends.count }.by(1)
    end

    it "should decline friend request" do
      expect { click_on 'Decline' }.to_not change { @user.friends.count }
    end
  end
end
