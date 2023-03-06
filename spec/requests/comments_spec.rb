require 'rails_helper'

RSpec.describe "Comments", type: :request do
  include Devise::Test::IntegrationHelpers

  fixtures :comments, :users

  before do
    sign_in @user = users(:one)
    @comment = comments(:one)
  end

  context "when user is not signed in" do
    before do
      sign_out @user
    end

    it "should redirect to user sign in page" do
      # /show
      get comment_path(@comment)
      expect(response).to redirect_to(new_user_session_path)
      # /new
      get new_comment_path
      expect(response).to redirect_to(new_user_session_path)
      # /edit
      get edit_comment_path(@comment)
      expect(response).to redirect_to(new_user_session_path)
      # /create
      post comments_path
      expect(response).to redirect_to(new_user_session_path)
      # /update
      patch comment_path(@comment)
      expect(response).to redirect_to(new_user_session_path)
      # /destroy
      delete comment_path(@comment)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "GET /show" do
    before do
      get comment_path(@comment)
    end

    it "should call show action" do
      expect(controller.action_name).to eq('show')
    end

    it "should redirect to commentable with anchor" do
      expect(response).to redirect_to([@comment.commentable, anchor: @comment.friendly_id])
    end

    it "should return http status code 303" do
      expect(response.status).to eq(303)
    end
  end

  # describe "GET /new" do
  # end

  describe "GET /edit" do
    before do
      get edit_comment_path(@comment)
    end

    it "should call edit action" do
      expect(controller.action_name).to eq('edit')
    end

    it "should render edit view" do
      expect(response).to render_template(:edit)
    end

    it "should return http status code 200" do
      expect(response.status).to eq(200)
    end
  end

  describe "POST /create" do
    let(:comment_params) { { body: 'Test comment', commentable_type: @comment.commentable_type, commentable_id: @comment.commentable_id } }

    before do
      post comments_path, params: { comment: comment_params }
    end

    it "should call create action" do
      expect(controller.action_name).to eq('create')
    end

    it "should assign commentable" do
      expect(assigns(:commentable)).to eq(@comment.commentable)
    end

    context "when comment is is valid" do
      it "should create comment" do
        expect { post comments_path, params: { comment: comment_params } }.to change { Comment.count }.by(1)
      end

      it "should redirect to commentable" do
        expect(response).to redirect_to(polymorphic_url(@comment.commentable, anchor: Comment.last.slug))
      end

      it "should assign flash message" do
        expect(flash[:notice]).to be_present
      end

      it "should return http status code 302" do
        expect(response.status).to eq(302)
      end
    end

    context "when comment is invalid" do
      before do
        comment_params[:body] = nil
        post comments_path, params: { comment: comment_params }
      end

      it "should render new view" do
        expect(response).to render_template(:new)
      end

      it "should assign flash.now message" do
        expect(flash.now[:alert]).to be_present
      end

      it "should return http status code 422" do
        expect(response.status).to eq(422)
      end

      context "when parent is present" do
        before do
          comment_params[:body] = nil
          post comments_path, params: { comment: comment_params.merge({ parent: @comment.slug }) }
        end

        it "should assign parent" do
          expect(assigns(:comment).ancestor).to eq(@comment)
        end
      end
    end
  end

  describe "PATCH /update" do
    before do
      patch comment_path(@comment), params: { comment: { body: 'Comment updated!' } }
    end

    it "should call update action" do
      expect(controller.action_name).to eq('update')
    end

    context "when comment is valid" do
      it "should update comment" do
        expect { patch comment_path(@comment), params: { comment: { body: 'Comment updated yet again!' } } }.to change { Comment.find(@comment.id).body }
      end

      it "should redirect to commentable" do
        expect(response).to redirect_to(@comment.commentable)
      end

      it "should assign flash message" do
        expect(flash[:notice]).to be_present
      end

      it "should return http status code 302" do
        expect(response.status).to eq(302)
      end
    end

    context "when comment is invalid" do
      before do
        patch comment_path(@comment), params: { comment: { body: nil } }
      end

      it "should render edit view" do
        expect(response).to render_template(:edit)
      end

      it "should assign flash.now message" do
        expect(flash.now[:alert]).to be_present
      end

      it "should return http status code 422" do
        expect(response.status).to eq(422)
      end
    end
  end

  describe "DELETE /destroy" do
    before do
      delete comment_path(@comment)
    end

    it "should call destroy action" do
      expect(controller.action_name).to eq('destroy')
    end

    it "should delete comment" do
      expect(Comment.all).to_not include(@comment)
    end

    it "should redirect to commentable" do
      expect(response).to redirect_to(@comment.commentable)
    end

    it "should assign flash message" do
      expect(flash[:alert]).to be_present
    end

    it "should return http status code 422" do
      expect(response.status).to eq(302)
    end
  end
end
