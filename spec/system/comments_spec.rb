require 'rails_helper'

RSpec.describe "Comments", type: :system do
  include Devise::Test::IntegrationHelpers

  fixtures :users

  before do
    driven_by(:rack_test)
    sign_in @user = users(:one)
    @post = @user.posts.first
    visit post_path(@post)
  end

  it "should create comment" do
    fill_in :comment_body, with: 'This is a test comment'

    expect { click_on 'Create Comment' }.to change { @post.comments.count }.by(1)
    expect(page).to have_current_path(post_path(@post))
  end

  it "should create reply" do
    comment = @post.comments.last

    within("##{comment.slug}") do
      click_on 'Reply'
    end
    fill_in :comment_body, with: 'This is a test reply'

    expect { click_on 'Create Comment' }.to change { comment.replies.count }.by(1)
    expect(page).to have_current_path(post_path(@post))
  end

  it "should edit comment" do
    comment = @post.comments.find_by(body: 'First comment')
    within("##{comment.slug}") do
      click_on 'Edit'
    end

    expect(page).to have_current_path("/comments/#{comment.slug}/edit")

    body = 'This is an edited test comment'
    fill_in :comment_body, with: body

    expect { click_on 'Update Comment' }.to change { comment.reload.body }.to(body)
    expect(page).to have_current_path(post_path(@post))
  end

  it "should like comment" do
    sign_in users(:two)
    visit post_path(@post)

    comment = @post.comments.find_by(body: 'First comment')

    expect { within("##{comment.slug}") { click_on 'Like' } }.to change { comment.likes.count }.by(1)
    expect(page).to have_current_path(post_path(@post))
  end

  it "should delete comment" do
    comment = @post.comments.find_by(body: 'Reply of reply')

    expect { within("##{comment.slug}") { click_on 'Delete' } }.to change { @post.comments.count }.by(-1)
    expect(page).to have_current_path(post_path(@post))
  end
end
