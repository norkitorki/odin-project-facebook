require 'rails_helper'

RSpec.describe "Users", type: :request do
  include Devise::Test::IntegrationHelpers

  fixtures :users

  before do
    sign_in @user = users(:one)
  end

  context "when user is not signed in" do
    before do
      sign_out @user
    end

    it "should redirect to user sign in page" do
      # /home
      get user_path(@user)
      expect(response).to redirect_to(new_user_session_path)
      # /comments
      get comments_user_path(@user)
      expect(response).to redirect_to(new_user_session_path)
      # /friends
      get friends_user_path(@user)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "GET /show" do
    before do
      get user_path(@user)
    end

    it "should call show action" do
      expect(controller.action_name).to eq('show')
    end

    it "should assign posts" do
      expect(assigns(:posts)).to eq(@user.posts)
    end

    it "should render show view" do
      expect(response).to render_template(:show)
    end

    it "should return http status code 200" do
      expect(response.status).to eq(200)
    end
  end

  describe "GET /comments" do
    before do
      get comments_user_path(@user)
    end

    it "should call comments action" do
      expect(controller.action_name).to eq('comments')
    end

    it "should assign comments" do
      expect(assigns(:comments)).to eq(@user.comments)
    end

    it "should render comments view" do
      expect(response).to render_template('comments')
    end

    it "should return http status code 200" do
      expect(response.status).to eq(200)
    end
  end

  describe "GET /friends" do
    before do
      get friends_user_path(@user)
    end

    it "should call friends action" do
      expect(controller.action_name).to eq('friends')
    end

    it "should assign friends" do
      expect(assigns(:friends)).to eq(@user.friends)
    end

    it "should render friends view" do
      expect(response).to render_template('friends')
    end

    it "should return http status code 200" do
      expect(response.status).to eq(200)
    end
  end
end
