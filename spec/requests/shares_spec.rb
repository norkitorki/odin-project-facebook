require 'rails_helper'

RSpec.describe "Shares", type: :request do
  include Devise::Test::IntegrationHelpers

  fixtures :shares, :users

  before do
    sign_in @user = users(:one)
    @share = shares(:one)
  end

  context "when user is not signed in" do
    before do
      sign_out @user
    end

    it "should redirect to user sign in page" do
      # /show
      get share_path(@share)
      expect(response).to redirect_to(new_user_session_path)
      # /new
      get new_share_path
      expect(response).to redirect_to(new_user_session_path)
      # /create
      post shares_path
      expect(response).to redirect_to(new_user_session_path)
      # /destroy
      delete share_path(@share)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "when user tries to perform an unauthorized action" do
    before do
      sign_in users(:three)
    end

    it "should be forbidden" do
      # /show
      get share_path(@share)
      expect(response).to be_forbidden
      # /new
      get new_share_path(shareable: { shareable_type: @share.shareable_type, shareable_id: @share.shareable_id })
      expect(response).to be_forbidden
      # /destroy
      delete share_path(@share)
      expect(response).to be_forbidden
    end
  end

  describe "GET /show" do
    it "should call show action" do
      get share_path(@share)
      expect(controller.action_name).to eq('show')
    end

    it "should redirect to shareable" do
      expect(get share_path(@share)).to redirect_to(@share.shareable)
    end

    it "should return http status code 303" do
      get share_path(@share)
      expect(response.status).to eq(303)
    end
  end

  describe "GET /new" do
    before do
      @share.user.friends << users(:three)
      get new_share_path(shareable: { shareable_type: @share.shareable_type, shareable_id: @share.shareable_id })
    end

    it "should call new action" do
      expect(controller.action_name).to eq('new')
    end

    it "should assign shareable_type from params" do
      expect(assigns(:shareable_type)).to be_present
    end

    it "should assign shareable_id from params" do
      expect(assigns(:shareable_id)).to be_present
    end

    it "should initialize share from params" do
      share = assigns(:share)
      expect(share).to be_new_record
      expect(share.shareable).to be_present
    end

    it "should assign users" do
      expect(assigns(:users)).to be_present
    end
  end

  describe "POST /create" do
    let(:params) {
      { shareable: { shareable_type: @share.shareable_type, shareable_id: @share.shareable_id, }, 
            users: [users(:three).slug, users(:four).slug] } }

    it "should call create action" do
      post shares_path, params: { share: params }
      expect(controller.action_name).to eq('create')
    end

    context "when no user has been selected" do
      before do
        params[:users] = nil
        post shares_path, params: { share: params }
      end

      it "should redirect to new_share_path" do
        expect(response).to redirect_to(new_share_path(shareable: params[:shareable]))
      end

      it "should display flash message" do
        expect(flash[:alert]).to be_present
      end

      it "should return http status code 302" do
        expect(response.status).to eq(302)
      end
    end

    it "should create shares for users" do
      expect { post shares_path, params: { share: params } }.to change { Share.count }.by(2)
    end

    it "should redirect to shareable" do
      post shares_path, params: { share: params }
      expect(response).to redirect_to(@share.shareable)
    end

    it "should display flash message" do
      post shares_path, params: { share: params }
      expect(flash[:notice]).to be_present
    end

    it "should return http status code 302" do
      post shares_path, params: { share: params }
      expect(response.status).to eq(302)
    end
  end

  describe "DELETE /destroy" do
    it "should call destroy action" do
      delete share_path(@share)
      expect(controller.action_name).to eq('destroy')
    end

    it "should delete share" do
      expect { delete share_path(@share) }.to change { Share.count }.by(-1)
    end

    it "should redirect to shares_path" do
      delete share_path(@share)
      expect(response).to redirect_to(shares_path)
    end

    it "should display flash message" do
      delete share_path(@share)
      expect(flash[:alert]).to be_present
    end

    it "should return http status code 302" do
      delete share_path(@share)
      expect(response.status).to eq(302)
    end
  end
end
