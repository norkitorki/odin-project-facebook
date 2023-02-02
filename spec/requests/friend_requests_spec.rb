require 'rails_helper'

RSpec.describe "FriendRequests", type: :request do
  include Devise::Test::IntegrationHelpers
  
  fixtures :friend_requests, :users

  before do
    sign_in @user = users(:one)
    @user_2 = users(:two)
    @friend_request = friend_requests(:one)
  end

  context "when user is not signed in" do
    before do
      sign_out @user
    end

    it "should redirect to user sign in page" do
      # /index
      get friend_requests_path
      expect(response).to redirect_to(new_user_session_path)
      # /show
      get friend_request_path(@friend_request)
      expect(response).to redirect_to(new_user_session_path)
      # /new
      get new_friend_request_path
      expect(response).to redirect_to(new_user_session_path)
      # /create
      post friend_requests_path
      expect(response).to redirect_to(new_user_session_path)
      # /destroy
      delete friend_request_path(@friend_request)
      expect(response).to redirect_to(new_user_session_path)
    end
  end
  
  describe "GET /index" do
    before do
      sign_in @user_2
      get friend_requests_path
    end

    it "should call index action" do
      expect(controller.action_name).to eq('index')
    end

    it "should assign friend_requests" do
      expect(assigns(:friend_requests)).to eq(@user_2.pending_friend_requests)
    end

    it "should render index view" do
      expect(response).to render_template(:index)
    end

    it "should return http status code 200" do
      expect(response.status).to eq(200)
    end
  end

  describe "GET /show" do
    before do
      get friend_request_path(@friend_request)
    end

    it "should call show action" do
      expect(controller.action_name).to eq('show')
    end

    it "should render show view" do
      expect(response).to render_template(:show)
    end

    it "should return http status code 200" do
      expect(response.status).to eq(200)
    end
  end

  describe "GET /new" do
    before do
      get new_friend_request_path, params: { candidate_id: @user_2.slug }
    end

    it "should call new action" do
      expect(controller.action_name).to eq('new')
    end

    context "when pending friend request exists" do
      before do
        sign_in @user_2
        get new_friend_request_path, params: { candidate_id: @user.slug }
      end

      it "should redirect to friend request" do
        expect(response).to redirect_to(@friend_request)
      end

      it "should assign flash message" do
        expect(flash[:alert]).to be_present
      end

      it "should return http status code 303" do
        expect(response.status).to eq(303)
      end
    end

    context "when no pending friend request exists" do
      it "should initialize new friend request" do
        friend_request = assigns(:friend_request)
        expect(friend_request).to be_new_record
        expect(friend_request.user).to eq(@user)
        expect(friend_request.candidate).to eq(@user_2)
      end

      it "should render new view" do
        expect(response).to render_template(:new)
      end

      it "should return http status code 200" do
        expect(response.status).to eq(200)
      end
    end
  end

  describe "POST /create" do
    let (:friend_request_params) { { candidate_id: @user.id, message: 'Wanna test our friendship?' } }

    before do
      sign_in @user_3 = users(:three)
      post friend_requests_path, params: { friend_request: friend_request_params }
    end

    it "should call create action" do
      expect(controller.action_name).to eq('create')
    end

    context "when friend request is valid" do
      it "should create friend request" do
        expect(FriendRequest.find_by(user: @user_3, candidate: @user)).to be_present
      end

      it "should redirect to root path" do
        expect(response).to redirect_to(root_path)
      end

      it "should assign flash message" do
        expect(flash[:notice]).to be_present
      end

      it "should return http status code 302" do
        expect(response.status).to eq(302)
      end
    end

    context "when friend request is invalid" do
      before do
        sign_in @user
        post friend_requests_path, params: { friend_request: friend_request_params }
      end

      it "should render new view" do
        expect(response).to render_template(:new)
      end

      it "should assign flash.now message" do
        expect(flash.now[:alert]).to be_present
      end

      it "should return http status code 422" do
        expect(response.status).to eq(422)
      end 
    end
  end

  describe "DELETE /destroy" do
    let(:params) { { commit: 'Accept' } }

    it "should call destroy action" do
      delete friend_request_path(@friend_request)
      expect(controller.action_name).to eq('destroy')
    end

    it "should delete friend request" do
      delete friend_request_path(@friend_request)
      expect(FriendRequest.all).to_not include(@friend_request)
    end

    it "should redirect to friend_requests_path" do
      delete friend_request_path(@friend_request), params: params
      expect(response).to redirect_to(friend_requests_path)
    end

    it "should assign flash message" do
      delete friend_request_path(@friend_request), params: params
      expect(flash[:notice]).to be_present
    end

    it "should return http status code 302" do
      delete friend_request_path(@friend_request), params: params
      expect(response.status).to eq(302)
    end

    context "when friend request was accepted" do
      before do
        sign_in @user_2
      end

      it "should create friendships" do
        expect { delete friend_request_path(@friend_request), params: params }.to change { Friendship.count }.by(2)
      end
    end
  end
end
