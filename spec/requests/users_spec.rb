require 'rails_helper'

RSpec.describe "Users", type: :request do
  include Devise::Test::IntegrationHelpers

  fixtures :users

  before do
    @user = users(:one)
    sign_in @user
  end

  describe "GET /show" do
    before do
      get user_path(@user)
    end

    it "should call show action" do
      expect(controller.action_name).to eq('show')
    end

    it "should return http status code 200" do
      expect(response.status).to eq(200)
    end

    it "should render show view" do
      expect(response).to render_template('show')
    end
  end

  describe "GET /activity" do
    before do
      get activity_user_path(@user)
    end

    it "should return http status code 200" do
      expect(response.status).to eq(200)
    end

    it "should call activity action" do
      expect(controller.action_name).to eq('activity')
    end

    it "should render activity view" do
      expect(response).to render_template('activity')
    end
  end

  describe "GET /posts" do
    before do
      get posts_user_path(@user)
    end

    it "should return http status code 200" do
      expect(response.status).to eq(200)
    end

    it "should call posts action" do
      expect(controller.action_name).to eq('posts')
    end

    it "should render posts view" do
      expect(response).to render_template('posts')
    end
  end

  describe "GET /comments" do
    before do
      get comments_user_path(@user)
    end

    it "should return http status code 200" do
      expect(response.status).to eq(200)
    end

    it "should call comments action" do
      expect(controller.action_name).to eq('comments')
    end

    it "should render comments view" do
      expect(response).to render_template('comments')
    end
  end

  describe "GET /friends" do
    before do
      get friends_user_path(@user)
    end

    it "should return http status code 200" do
      expect(response.status).to eq(200)
    end

    it "should call friends action" do
      expect(controller.action_name).to eq('friends')
    end

    it "should render friends view" do
      expect(response).to render_template('friends')
    end
  end
end