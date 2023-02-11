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

  it "should send friend request" do
    FriendRequest.destroy_all
    visit user_path(user_2 = users(:two))

    click_on 'Send Friend Request'

    expect(page).to have_current_path(new_friend_request_path(candidate_id: user_2.slug))
    expect { click_on 'Send' }.to change { @user.friend_requests.count }.by(1)
  end

  context "when user has recevied friend request" do
    before do
      FriendRequest.destroy_all
      visit user_path(user_2 = users(:two))

      click_on 'Send Friend Request'
      click_on 'Send'

      sign_in user_2
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
