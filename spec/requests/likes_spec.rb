require 'rails_helper'

RSpec.describe "Likes", type: :request do
  include Devise::Test::IntegrationHelpers

  fixtures :posts, :users

  before do
    @post = posts(:two)
    sign_in @user = users(:one)
    @user_2 = users(:two)
  end

  describe "POST /create" do
    before do
      post likes_path, params: { likeable: { likeable_type: 'Post', likeable_id: @post.id } }
    end

    it "should call create action" do
      expect(controller.action_name).to eq('create')
    end

    it "should assign flash message" do
      expect(flash).to be_present
    end

    it "should return http status code 302" do
      expect(response.status).to eq(302)
    end

    context "when like is valid" do
      it "should create like" do
        sign_in users(:three)
        expect { post likes_path, params: { likeable: { likeable_type: 'Post', likeable_id: @post.id } } }.to change { Like.count }.by(1)
      end
    end

    context "when path param is assigned" do
      it "should redirect to path" do
        post likes_path, params: { likeable: { likeable_type: 'Post', likeable_id: @post.id }, path: post_path(@post) }
        expect(response).to redirect_to(@post)
      end
    end

    context "when path param is not assigned" do
      it "should redirect to root_path" do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE /destroy" do
    before do
      @like = Like.create(user: @user, likeable: @post)
    end

    it "should call destroy action" do
      delete like_path(@like)
      expect(controller.action_name).to eq('destroy')
    end

    it "should delete like" do
      expect { delete like_path(@like) }.to change { Like.count }.by(-1)
    end

    it "should assign flash message" do
      delete like_path(@like)
      expect(flash).to be_present
    end

    it "should return http status code 302" do
      delete like_path(@like)
      expect(response.status).to eq(302)
    end

    context "when path param is assigned" do
      it "should redirect to path" do
        delete like_path(@like), params: { path: post_path(@post) }
        expect(response).to redirect_to(@post)
      end
    end

    context "when path param is not assigned" do
      it "should redirect to root_path" do
        delete like_path(@like)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
