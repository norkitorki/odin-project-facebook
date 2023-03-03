require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  include Devise::Test::IntegrationHelpers

  fixtures :users

  before do
    driven_by(:rack_test)
    sign_in @user = users(:one)
  end

  it "should view home" do
    visit root_path
    expect(page).to have_current_path(root_path)
  end

  it "should view discover" do
    visit root_path

    click_on 'Discover'
    expect(page).to have_current_path(discover_path)
  end
end
