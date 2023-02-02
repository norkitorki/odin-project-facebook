require 'rails_helper'

RSpec.describe "Friendships", type: :request do
  include Devise::Test::IntegrationHelpers

  fixtures :users

  let(:params) { { user_id: @user.id, friend_id: @user_2.id } }

  before do
    sign_in @user = users(:one)
    @user_2 = users(:two)
    @friendship = Friendship.create(user: @user, friend: @user_2)
  end

  context "when user is not signed in" do
    before do
      sign_out @user
    end

    it "should redirect to user sign in page" do
      # /destroy
      delete friendship_path(@friendship), params: params
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "DELETE /destroy" do
    it "should call destroy action" do
      delete friendship_path(@friendship), params: params
      expect(controller.action_name).to eq('destroy')
    end

    it "should delete friendships" do
      expect { delete friendship_path(@friendship), params: params }.to change { Friendship.count }.by(-2)
    end

    it "should redirect to user" do
      delete friendship_path(@friendship), params: params
      expect(response).to redirect_to(@user)
    end

    it "should assign flash message" do
      delete friendship_path(@friendship), params: params
      expect(flash[:alert]).to be_present
    end

    it "should return http status code 302" do
      delete friendship_path(@friendship), params: params
      expect(response.status).to eq(302)
    end
  end
end
