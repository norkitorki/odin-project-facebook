require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  include Devise::Test::IntegrationHelpers
  include RSpec::Rails::Matchers::RoutingMatchers

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
      get home_path
      expect(response).to redirect_to(new_user_session_path)
      # /discover
      get discover_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "GET /home" do
    before do
      get home_path
    end

    it "should be root_path" do
      expect(get: root_path).to route_to(controller: 'static_pages', action: 'home')
    end

    it "should call home action" do
      expect(controller.action_name).to eq('home')
    end

    it "should initialize post" do
      expect(assigns(:post)).to be_new_record
    end

    it "should assign page" do
      expect(assigns(:page)).to be_present
    end

    it "should assign posts" do
      expect(assigns(:posts)).to be_present
    end

    it "should render home view" do
      expect(response).to render_template(:home)
    end

    it "should return http status code 200" do
      expect(response.status).to eq(200)
    end
  end

  describe "GET /discover" do
    before do
      get discover_path
    end

    it "should call discover action" do
      expect(controller.action_name).to eq('discover')
    end

    it "should assign users" do
      expect(assigns(:users)).to be_present
    end

    it "should assign page" do
      expect(assigns(:page)).to be_present
    end

    it "should render discover view" do
      expect(response).to render_template(:discover)
    end

    it "should return http status code 200" do
      expect(response.status).to eq(200)
    end
  end
end
