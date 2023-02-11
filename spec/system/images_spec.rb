require 'rails_helper'

RSpec.describe "Images", type: :system do
  include Devise::Test::IntegrationHelpers

  fixtures :users

  let(:image_file) { "#{Rails.root}/app/assets/images/placeholder.png" }

  before do
    driven_by(:rack_test)
    sign_in @user = users(:one)
  end

  describe "user" do
    let(:password) { 'somePassword123' }

    before do
      @user.update(password: password)
      @user.image.update(remove_photo: true)
      sign_in @user
      visit edit_user_registration_path(@user)
      fill_in 'Current Password', with: password
    end

    after do
      expect(page).to have_current_path(user_path(@user))
      @user.image.destroy!
    end

    it "should upload local photo" do
      attach_file('Local Photo', image_file)

      expect { click_on 'Update' }.to change { @user.reload.image.photo.file }
    end

    it "should update remote photo" do
      remote_photo = 'https://photos.com/img.png'
      fill_in 'Photo Url', with: remote_photo
      
      expect { click_on 'Update' }.to change { @user.reload.image.remote_photo }.to(remote_photo)
    end

    it "should delete local photo" do
      attach_file('Local Photo', image_file)
      click_on 'Update'

      visit edit_user_registration_path(@user)
      fill_in 'Current Password', with: password
      page.check('user_image_attributes_remove_photo')

      expect { click_on 'Update' }.to change { @user.reload.image.photo.file }.to(nil)
    end
  end

  describe "post" do
    before do
      @post = @user.posts.first
      visit edit_post_path(@post)
    end

    after do
      expect(page).to have_current_path(post_path(@post))
      @post.images.destroy_all
    end

    it "should upload local photos" do
      attach_file('post_images_attributes_1_photo', image_file)

      expect { click_on 'Update Post' }.to change { @post.images.count }.by(1)
    end

    it "should update remote photos" do
      fill_in 'post_images_attributes_1_remote_photo', with: 'https://somewebsite.com/someimage.png'
      fill_in 'post_images_attributes_2_remote_photo', with: 'https://someotherwebsite.com/someimage.png'

      expect { click_on 'Update Post' }.to change { @post.images.count }.by(2)
    end

    it "should delete local photos" do
      attach_file('post_images_attributes_1_photo', image_file)
      click_on 'Update Post'
      visit edit_post_path(@post)

      check('post_images_attributes_1__destroy')

      expect { click_on 'Update Post' }.to change { @post.images.count }.by(-1)
    end

    it "should delete remote photos" do
      check('post_images_attributes_0__destroy')

      expect { click_on 'Update Post' }.to change { @post.images.count }.by(-1)
    end
  end
end
