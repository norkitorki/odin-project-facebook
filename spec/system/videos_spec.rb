require 'rails_helper'

RSpec.describe "Videos", type: :system do
  include Devise::Test::IntegrationHelpers

  fixtures :users

  let (:video_file) { "#{Rails.root}/app/assets/videos/jellyfish.mp4" }

  before do
    driven_by(:rack_test)
    sign_in @user = users(:one)
  end

  describe "post" do
    let(:post) { @user.posts.first }

    before do
      post.video.destroy!
      visit edit_post_path(post)
    end

    after do
      expect(page).to have_current_path(post_path(post))
      post.video.destroy! if post.video
    end

    it "should upload local video" do
      visit edit_post_path(post)

      attach_file 'post_video_attributes_video', video_file

      expect { click_on 'Update Post' }.to change { post.reload.video }.from(nil).to be_instance_of(Video)
    end

    it "should update remote video" do
      visit edit_post_path(post)

      remote_video = 'https://website.com/somevideo.webm'
      fill_in 'post_video_attributes_remote_video', with: remote_video

      expect { click_on 'Update Post' }.to change { post.reload.video }.from(nil).to be_instance_of(Video)
      expect(post.video.remote_video).to eq(remote_video)
    end

    it "should delete local video" do
      attach_file 'post_video_attributes_video', video_file
      click_on 'Update'

      visit edit_post_path(post)
      check 'post_video_attributes__destroy'

      expect { click_on 'Update Post' }.to change { post.reload.video }.to(nil)
    end
  end
end
