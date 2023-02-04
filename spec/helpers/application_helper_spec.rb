require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#generate_uuid" do
    it "should return random uuid in url safe format" do
      expect(helper.generate_uuid).to match(/^[a-zA-Z0-9\-_]{22}$/)
    end
  end
end
