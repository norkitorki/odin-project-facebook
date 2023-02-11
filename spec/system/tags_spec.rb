require 'rails_helper'

RSpec.describe "Tags", type: :system do
  include Devise::Test::IntegrationHelpers

  fixtures :users

  before do
    driven_by(:rack_test)
    sign_in @user = users(:one)
  end

  it "should view all tags" do
    visit root_path

    click_on 'Tags'

    expect(page).to have_current_path(tags_path)
  end

  it "should view tag" do
    visit root_path

    click_on 'Tags'
    click_on tag = 'technology'

    expect(page).to have_current_path(tag_path(s: tag))
  end
end
