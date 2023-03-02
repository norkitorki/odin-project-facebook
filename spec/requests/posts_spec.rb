require 'rails_helper'

RSpec.describe "Posts", type: :request do
  include Devise::Test::IntegrationHelpers

  fixtures :posts, :users

  before do
    @post = posts(:one)
    sign_in @user = users(:one)
  end

  context "when user is not signed in" do
    before do
      sign_out @user
    end

    it "should redirect to user sign in page" do
      # /show
      get post_path(@post)
      expect(response).to redirect_to(new_user_session_path)
      # /new
      get new_post_path
      expect(response).to redirect_to(new_user_session_path)
      # /edit
      get edit_post_path(@post)
      expect(response).to redirect_to(new_user_session_path)
      # /create
      post posts_path
      expect(response).to redirect_to(new_user_session_path)
      # /update
      patch post_path(@post)
      expect(response).to redirect_to(new_user_session_path)
      # /destroy
      delete post_path(@post)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "when user tries to perform an unauthorized action" do
    before do
      sign_in users(:two)
    end

    it "should be forbidden" do
      # /edit
      get edit_post_path(@post)
      expect(response).to be_forbidden
      # /update
      patch post_path(@post)
      expect(response).to be_forbidden
      # /destroy
      delete post_path(@post)
      expect(response).to be_forbidden
    end
  end

  describe "GET /show" do
    before do
      get post_path(@post)
    end

    it "should call show action" do
      expect(controller.action_name).to eq('show')
    end

    it "should initialize comment" do
      expect(assigns(:comment)).to be_new_record
    end

    it "should assign page" do
      expect(assigns(:page)).to be_present
    end

    it "should assign comments" do
      expect(assigns(:comments)).to be_present
    end

    it "should assign like" do
      expect(assigns(:like)).to be_present
    end

    it "should assign tags" do
      expect(assigns(:tags)).to be_present
    end

    it "should render show view" do
      expect(response).to render_template(:show)
    end

    it "should return http status code 200" do
      expect(response.status).to eq(200)
    end
  end

  describe "GET /new" do
    before do
      get new_post_path
    end

    it "should call new action" do
      expect(controller.action_name).to eq('new')
    end

    it "should initialize post" do
      expect(assigns(:post)).to be_new_record
    end

    it "should initialize links" do
      expect(assigns(:post).links).to all(be_new_record)
    end

    it "should initialize images" do
      expect(assigns(:post).images).to all(be_new_record)
    end

    it "should initialize tag list" do
      expect(assigns(:post).tag_list).to be_new_record
    end

    it "should initiailize video" do
      expect(assigns(:post).video).to be_new_record
    end

    it "should render new view" do
      expect(response).to render_template(:new)
    end

    it "should return http status code 200" do
      expect(response.status).to eq(200)
    end
  end

  describe "GET /edit" do
    before do
      get edit_post_path(@post)
    end

    it "should call edit action" do
      expect(controller.action_name).to eq('edit')
    end

    it "should assign links" do
      expect(assigns(:post).links).to be_present
    end

    it "should assign images" do
      expect(assigns(:post).images).to be_present
    end

    it "should assign tag list" do
      expect(assigns(:post).tag_list).to be_present
    end

    it "should assign video" do
      expect(assigns(:post).video).to be_present
    end

    it "should render edit view" do
      expect(response).to render_template(:edit)
    end

    it "should return http status code 200" do
      expect(response.status).to eq(200)
    end
  end

  describe "POST /create" do
    let(:params) { { content: 'This is a test post!' } }

    before do
      post posts_path, params: { post: params }
    end

    it "should call create action" do
      expect(controller.action_name).to eq('create')
    end

    context "when post is valid" do
      it "should create post" do
        expect { post posts_path, params: { post: params } }.to change { Post.count }.by(1)
      end

      it "should redirect to post" do
        expect(response).to redirect_to(assigns(:post))
      end

      it "should assign flash message" do
        expect(flash[:notice]).to be_present
      end

      it "should return http status code 302" do
        expect(response.status).to eq(302)
      end
    end

    context "when post is invalid" do
      before do
        post posts_path, params: { post: { content: nil } }
      end

      it "should initialize links" do
        expect(assigns(:post).links).to all(be_new_record)
      end
  
      it "should initialize images" do
        expect(assigns(:post).images).to all(be_new_record)
      end
  
      it "should initialize tag list" do
        expect(assigns(:post).tag_list).to be_new_record
      end
  
      it "should initiailize video" do
        expect(assigns(:post).video).to be_new_record
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
    end
  end

  describe "PATCH /update" do
    before do
      patch post_path(@post), params: { post: { content: 'Post just got updated.' } }
    end

    it "should call update action" do
      expect(controller.action_name).to eq('update')
    end

    context "when post is valid" do
      it "should update post" do
        expect { patch post_path(@post), params: { post: { content: 'Updated again!' } } }.to change { Post.find(@post.id).content }
      end

      it "should redirect to post" do
        expect(response).to redirect_to(assigns(:post))
      end

      it "should assign flash message" do
        expect(flash[:notice]).to be_present
      end

      it "should return http status code 302" do
        expect(response.status).to eq(302)
      end
    end

    context "when post is invalid" do
      before do
        post = Post.create(content: 'Am I invalid?', user: @user)
        patch post_path(post), params: { post: { content: nil } }
      end

      it "should assign links" do
        expect(assigns(:post).links).to be_present
      end
  
      it "should assign images" do
        expect(assigns(:post).images).to be_present
      end
  
      it "should assign tag list" do
        expect(assigns(:post).tag_list).to be_present
      end
  
      it "should assign video" do
        expect(assigns(:post).video).to be_present
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
    it "should call destroy action" do
      delete post_path(@post)
      expect(controller.action_name).to eq('destroy') 
    end

    it "should delete post" do
      expect { delete post_path(@post) }.to change { Post.count }.by(-1)
    end

    it "should redirect to root_path" do
      delete post_path(@post)
      expect(response).to redirect_to(root_path)
    end

    it "should assign flash message" do
      delete post_path(@post)
      expect(flash[:notice]).to be_present
    end

    it "should return http status code 302" do
      delete post_path(@post)
      expect(response.status).to eq(302)
    end
  end
end
