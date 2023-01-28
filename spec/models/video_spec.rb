require 'rails_helper'

RSpec.describe Video, type: :model do
  fixtures :videos

  before do
    @video_1 = videos(:one)
    @video_2 = videos(:two)
  end

  it "should be valid with video,remote_video and videoable" do
    @video_1.remote_video = 'https://somewebsite.com/some_video.mp4'
    expect(@video_1).to be_valid
  end

  it "should be valid without video" do
    expect(@video_2).to be_valid
  end

  it "should be valid without remote_video" do
    expect(@video_1).to be_valid
  end

  it "should be invalid without videoable" do
    @video_1.videoable = nil
    expect(@video_1).to_not be_valid
  end

  describe "#to_s" do
    it "should return video_url" do
      expect(@video_1.to_s).to eq(@video_1.video_url)
    end
  end

  describe "#video_present?" do
    it "should return true with video" do
      expect(@video_1.video_present?).to be true
    end

    it "should return true with remote_video" do
      expect(@video_2.video_present?).to be true
    end

    it "should return true with video and remote_video" do
      @video_1.remote_video = 'https://somewebsite.com/some_video.mp4'
      expect(@video_1.video_present?).to be true
    end

    it "should return false without video and remote_video" do
      @video_2.remote_video = nil
      expect(@video_2.video_present?).to be false
    end

    it "should return false when remote_video is empty" do
      @video_2.remote_video = ''
      expect(@video_2.video_present?).to be false
    end
  end
end
