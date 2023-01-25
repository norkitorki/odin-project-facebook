require 'rails_helper'

RSpec.describe Image, type: :model do
  fixtures 'images'

  before do
    @image_1 = images(:one)
    @image_2 = images(:two)
  end

  it "should be valid with photo and remote_photo" do
    @image_1.remote_photo = 'https://example.com/some_image.png'
    expect(@image_1).to be_valid
  end

  it "should be valid without photo" do
    @image_1.photo = nil
    expect(@image_1).to be_valid
  end

  it "should be valid without remote_photo" do
    expect(@image_1).to be_valid
  end

  it "should be invalid without imageable" do
    @image_1.imageable = nil
    expect(@image_1).to_not be_valid
  end

  context "#to_s" do
    it "should return photo_url" do
      expect(@image_1.to_s).to eq(@image_1.photo_url)
    end
  end

  context "#image_present?" do
    it "should return true with photo" do
      expect(@image_1.image_present?).to be true
    end

    it "should return true with remote_photo" do
      expect(@image_2.image_present?).to be true
    end

    it "should return true with photo and remote_photo" do
      @image_1.remote_photo = 'https://example.com/some_image.png'
      expect(@image_1.image_present?).to be true
    end

    it "should return false without photo and remote_photo" do
      @image_2.remote_photo = nil
      expect(@image_2.image_present?).to be false
    end
  end
end
