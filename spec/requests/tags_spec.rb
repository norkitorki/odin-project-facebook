require 'rails_helper'

RSpec.describe "Tags", type: :request do
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
      # /index
      get tags_path
      expect(response).to redirect_to(new_user_session_path)
      # /show
      get tag_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "GET /index" do
    before do
      get tags_path
    end

    it "should call index actiom" do
      expect(controller.action_name).to eq('index')
    end

    it "should assign tags" do
      expect(assigns(:tags)).to be_present
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
      get tag_path, params: { s: 'web' }
    end

    it "should call show action" do
      expect(controller.action_name).to eq('show')
    end

    it "should assign tag" do
      expect(assigns(:tag)).to eq('web')
    end

    it "should assign posts" do
      expect(assigns(:posts)).to be_present
    end
  end
end
