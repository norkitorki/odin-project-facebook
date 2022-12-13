class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, except: %i[ new create ]

  def show
    @comment  = @post.comments.new
    @comments = @post.comments.parents.includes(:user, :likes, :replies).order(created_at: :desc)
    @like     = @post.find_or_initialize_like(current_user)
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to @post, notice: 'Post has been successfully created.'
    else
      flash.now[:alert] = 'Post has not been created.'
    end
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post has been successfully updated.'
    else
      flash.now[:alert] = 'Post has not been updated.'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path, notice: 'Post has been successfully deleted.'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content)
  end
end
