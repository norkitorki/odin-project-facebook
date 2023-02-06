require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  # include Devise::Test::IntegrationHelpers
  # include ActiveJob::TestHelper

  describe "GET /new" do
    before do
      get new_user_registration_path
    end

    it "should initialize image" do
      expect(assigns(:user).image).to be_new_record
    end

    it "should render photo_field partial" do
      expect(response).to render_template(:_photo_field)
    end
  end

  describe "POST /create" do
    it "should enqueue welcome email" do
      expect { post user_registration_path, params: { user: { email: 'test@tester.net', first_name: 'Mister', last_name: 'Tester', birthday: Time.now - 20.years, password: '********' } } }
        .to have_enqueued_job.on_queue('default').exactly(:once)
    end
  end
end
