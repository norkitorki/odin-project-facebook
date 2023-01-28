require 'rails_helper'

RSpec.describe LikesHelper, type: :helper do
  fixtures :posts, :users

  before do
    @post = posts(:one)
    @user = users(:two)
  end

  describe "#liked_by?" do
    context "when user has liked likeable" do
      it "should return true" do
        @post.likes.create!(user: @user)
        expect(@post.liked_by?(@user)).to be true
      end
    end

    context "when user has not liked likeable" do
      it "should return false" do
        expect(@post.liked_by?(@user)).to be false
      end
    end
  end

  describe "#find_or_initialize_like" do
    context "when user has liked likeable" do
      it "should return the like" do
        @post.likes.create!(user: @user)
        like = @post.find_or_initialize_like(@user)
        expect(like.new_record?).to be false
      end
    end

    context "when user has not liked likeable" do
      it "should initialize a new like" do
        like = @post.find_or_initialize_like(@user)
        expect(like.new_record?).to be true
      end
    end
  end
end
