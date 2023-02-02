require 'rails_helper'

RSpec.describe "Notifications", type: :request do
  include Devise::Test::IntegrationHelpers

  fixtures :notifications, :users

  before do
    @notification = notifications(:one)
    sign_in @user = users(:one)
  end

  context "when user is not signed in" do
    before do
      sign_out @user
    end

    it "should redirect to user sign in page" do
      # /index
      get notifications_path
      expect(response).to redirect_to(new_user_session_path)
      # /show
      get notification_path(@notification)
      expect(response).to redirect_to(new_user_session_path)
      # /destroy
      delete notification_path(@notification)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "GET /index" do
    before do
      get notifications_path
    end

    it "should call index action" do
      expect(controller.action_name).to eq('index')
    end

    it "should assign notifications_by_date" do
      expect(assigns(:notifications_by_date)).to be_present
    end

    it "should render index view" do
      expect(response).to render_template(:index)
    end

    it "should return http status code 200" do
      expect(response.status).to eq(200)
    end
  end

  describe "GET /show" do
    it "should call show action" do
      get notification_path(@notification)
      expect(controller.action_name).to eq('show')
    end

    it "should update read" do
      expect { get notification_path(@notification) }.to change { Notification.find(@notification.id).read }.to(true)
    end

    it "should return http status code 301" do
      get notification_path(@notification)
      expect(response.status).to eq(301)
    end

    context "when path is assigned" do
      it "should redirect to path" do
        get notification_path(@notification)
        expect(response).to redirect_to(@notification.path)
      end
    end

    context "when path is not assigned" do
      it "should redirect to notifiable" do
        @notification.update(path: nil)
        get notification_path(@notification)
        expect(response).to redirect_to(@notification.notifiable)
      end
    end
  end

  describe "DELETE /destroy" do
    before do
      delete notification_path(@notification)
    end

    it "should call destroy action" do
      expect(controller.action_name).to eq('destroy')
    end

    it "should delete notification" do
      notification = @notification.dup
      notification.save!
      expect { delete notification_path(notification) }.to change { Notification.count }.by(-1)
    end

    it "should redirect to notifications_path" do
      expect(response).to redirect_to(notifications_path)
    end

    it "should assign flash message" do
      expect(flash[:alert]).to be_present
    end

    it "should return http status code 302" do
      expect(response.status).to eq(302)
    end
  end
end
