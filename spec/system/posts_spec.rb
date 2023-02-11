require 'rails_helper'

RSpec.describe "Posts", type: :system do
  include Devise::Test::IntegrationHelpers

  fixtures :users, :posts

  before do
    driven_by(:rack_test)
    sign_in @user = users(:one)
  end

  it "should create post" do
    visit root_path

    click_on 'Create New Post'
    content = 'This is a test post.'
    fill_in 'Content', with: content
    fill_in 'Tags', with: 'test,post'

    expect { click_on 'Create Post' }.to change { Post.count }.by(1)
    assert_text content
  end

  it "should view post" do
    visit root_path
    post = posts(:one)

    within("#post_#{post.slug}") do
      click_on 'Show'
    end

    expect(page).to have_current_path(post_path(post))
  end

  it "should edit post" do
    visit root_path
    post = posts(:one)

    within("#post_#{post.slug}") do
      click_on 'Edit'
    end

    expect(page).to have_current_path(edit_post_path(post))

    content = 'Post just got edited!'
    fill_in 'Content', with: content

    expect { click_on 'Update Post' }.to change { post.reload.content }.to(content)
    expect(page).to have_current_path(post_path(post))
  end

  it "should delete post" do
    visit root_path
    post = posts(:one)
    
    expect { within("#post_#{post.slug}") { click_on 'Delete' } }.to change { Post.count }.by(-1)
    expect(page).to have_current_path(root_path)
  end

  it "should like post" do
    post = posts(:two)
    visit post_path(post)

    expect { within("#post_#{post.slug}") { click_on 'Like' } }.to change { post.likes.count }.by(1)
    expect(page).to have_current_path(post_path(post))
  end
end
