require 'rails_helper'

RSpec.describe Comment, type: :model do
  fixtures :comments

  before do
   @comment = comments(:one)
  end

  it "should be valid with a user,commentable and body" do
    expect(@comment).to be_valid
  end

  it "should be invalid without a user" do
    @comment.user = nil
    expect(@comment).to_not be_valid
  end

  it "should be invalid without a commentable" do
    @comment.commentable = nil
    expect(@comment).to_not be_valid
  end

  it "should be invalid without a body" do
    @comment.body = nil
    expect(@comment).to_not be_valid
  end

  it "should find root comments" do
    expect(Comment.root).to include @comment
    expect(Comment.root).to_not include(comments(:reply))
  end

  it "should have replies one-to-many association" do
    reply = comments(:reply)
    expect(reply.parent).to eq(@comment.slug)
    expect(@comment.replies).to include(reply)
  end

  context 'replies' do
    it "should return the ancestor comment" do
      expect(comments(:reply).ancestor).to eq(@comment)
    end
  end

  it "should respond to edited?" do
    expect(@comment).to respond_to(:edited?)
  end

  it "should collect subcomments(replies) in a nested hash" do
    replies_hash = @comment.collect_replies
    expected_hash = { comments(:reply) => { comments(:reply_of_reply) => {} } }
    expect(replies_hash).to eq(expected_hash)
  end
end
