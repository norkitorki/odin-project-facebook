require 'rails_helper'

RSpec.describe "Shares", type: :system do
  include Devise::Test::IntegrationHelpers

  fixtures :shares, :users

  before do
    driven_by(:rack_test)
    sign_in @user = users(:two)
    @share = shares(:one)
    @post  = @user.posts.first
  end

  it "should share post" do
    @user.friends << users(:three)
    visit post_path(@post)

    within("#post_#{@post.slug}") do
      click_on 'Share'
    end

    check 'share_users_alex_hitchens'
    click_on 'Share'

    expect(page).to have_current_path(post_path(@post))
    assert_text 'Post has been shared.'
  end

  it "should view shared posts" do
    sign_in @share.user

    visit root_path
    click_on 'Shares'

    expect(page).to have_current_path(shares_path)
  end

  it "should visit shared post through notifications" do
    share = @share.dup
    @share.destroy
    share.save!

    sign_in @share.user

    visit notifications_path

    within("#notification_#{share.notification.slug}") do
      click_on 'Jane Doe has shared a Post with you.'
    end
   
    expect(page).to have_current_path(post_path(share.shareable))
  end

  it "should visit shared post" do
    sign_in @share.user

    visit shares_path

    within("#share_#{@share.slug}") do
      click_on 'Show'
    end

    expect(page).to have_current_path(post_path(@share.shareable))
  end

  it "should delete share" do
    sign_in @share.user

    visit shares_path

    within("#share_#{@share.slug}") do
      click_on 'share-delete'
    end
  end
end
