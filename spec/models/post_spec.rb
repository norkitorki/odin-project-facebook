require 'rails_helper'

RSpec.describe Post, type: :model do
  fixtures :posts, :images, :videos

  before do
    @post = posts(:one)
  end

  it "should be valid with content and user" do
    @post.images.destroy_all
    @post.video = nil
    expect(@post).to be_valid
  end

  it "should be valid with content,user and images" do
    @post.video = nil
    expect(@post).to be_valid
  end

  it "should be valid with content,user and video" do
    @post.images.destroy_all
    expect(@post).to be_valid
  end

  context "when content is nil" do
    before do
      @post.content = nil
    end

    it "should be valid with user and images" do
      @post.video = nil
      expect(@post).to be_valid
    end

    it "should be valid with user and video" do
      @post.images.destroy_all
      expect(@post).to be_valid
    end

    it "should be invalid without images and video" do
      @post.images.destroy_all
      @post.video = nil
      expect(@post).to_not be_valid
    end
  end

  context "when content is empty" do
    before do
      @post.content = ''
    end

    it "should be valid with user and images" do
      @post.video = nil
      expect(@post).to be_valid
    end

    it "should be valid with user and video" do
      @post.images.destroy_all
      expect(@post).to be_valid
    end

    it "should be invalid without images and video" do
      @post.images.destroy_all
      @post.video = nil
      expect(@post).to_not be_valid
    end
  end

  describe "#self.find_by_tag" do
    it "should find single post by tag" do
      expect(subject.class.find_by_tag('programming').to_a).to eq([@post])
    end

    it "should find multiple posts by tag" do
      expect(subject.class.find_by_tag('web').to_a).to eq(posts)
    end

    it "should return an empty array when no post corresponds to tag" do
      expect(subject.class.find_by_tag('test').to_a).to eq([])
    end
  end

  it "should respond to edited?" do
    expect(@post).to respond_to(:edited?)
    @post.update(content: 'test')
    expect(@post.edited?).to be true
  end

  describe '#all_images_destroyed?' do
    it "should return true if images are empty" do
      @post.images.destroy_all
      expect(@post.all_images_destroyed?).to be true
    end

    it "should return true when all images are deleted" do
      @post.images.first.destroy
      expect(@post.all_images_destroyed?).to be true
    end

    it "should return false when all images are not deleted" do
      @post.images << images(:one)
      expect(@post.all_images_destroyed?).to be false
    end
  end
end
