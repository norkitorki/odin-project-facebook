require 'rails_helper'

RSpec.describe Like, type: :model do
  fixtures 'users'
  fixtures 'posts'

  before do
    @like = Like.new(user: users(:one), likeable: posts(:two))
  end

  it "should be valid with user and likeable" do
    expect(@like).to be_valid
  end

  it "should be invalid without a user" do
    @like.user = nil
    expect(@like).to_not be_valid
  end
  
  it "should be invalid without a likeable" do
    @like.likeable = nil
    expect(@like).to_not be_valid
  end

  it "should be invalid when user is likeable.user" do
    @like.likeable = posts(:one)
    expect(@like).to_not be_valid
  end

  it "should be invalid when like already exists" do
    @like.save!
    expect(@like.dup).to_not be_valid
  end
end
