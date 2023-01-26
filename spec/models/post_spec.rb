require 'rails_helper'

RSpec.describe Post, type: :model do
  fixtures :posts, :images, :videos

  before do
    @post = posts(:one)
  end

  it "should be valid with content and user" do
    expect(@post).to be_valid
  end

  it "should be valid without content but with images" do
    @post.content = nil
    @post.images << images(:one)
    expect(@post).to be_valid
  end

  it "should be valid without content but with video" do
    @post.content = nil
    expect(@post.video).to eq(videos(:one))
    expect(@post).to be_valid
  end

  it "should respond to edited?" do
    expect(@post).to respond_to(:edited?)
    @post.update(content: 'test')
    expect(@post.edited?).to be true
  end

  context '#all_images_destroyed?' do
    it "should return true if images are empty" do
      expect(@post.all_images_destroyed?).to be true
    end

    it "should return true when all images are deleted" do
      @post.images << images(:one)
      @post.images.first.destroy
      expect(@post.all_images_destroyed?).to be true
    end

    it "should return false when all images are not deleted" do
      @post.images << images(:one)
      expect(@post.all_images_destroyed?).to be false
    end
  end
end
