require 'rails_helper'

RSpec.describe Link, type: :model do
  fixtures 'links'

  before do
    @link = links(:one)
  end

  it "should be valid with body and linkable" do
    expect(@link).to be_valid
  end

  it "should be invalid without body" do
    @link.body = nil
    expect(@link).to_not be_valid
  end

  it "should be invalid without linkable" do
    @link.linkable = nil
    expect(@link).to_not be_valid
  end

  it "should validate that body is a valid url" do
    @link.body = 'https://årø.no'
    expect(@link).to_not be_valid

    @link.body = 'http://www.google.com'
    expect(@link).to be_valid
  end

  context "when body doesn't begin with a scheme" do
    it "should prepend scheme before saving" do
      @link.body = 'example.com'
      expect { @link.save! }.to change { @link.body }.to('http://example.com')
    end
  end

  context "when body begins with a scheme" do
    it "should do nothing" do
      expect { @link.save! }.to_not change { @link.body }
    end
  end
end
