class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, except: %i[ new create ]
  before_action :set_page, only: :show
  before_action :authorize_user, only: %i[ edit update destroy ]

  def show
    @comment      = Comment.new
    post_comments = @post.comments.root.includes(:likes, :replies, :user)
    @comments     = resource_pagination(post_comments, @page, 20)
    @like         = @post.find_or_initialize_like(current_user)
    @tags         = @post.tag_list.to_a
  end

  def new
    @post = Post.new
    initialize_assocations
  end

  def edit
    initialize_assocations
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to @post, notice: 'Post has been successfully created.'
    else
      initialize_assocations
      flash.now[:alert] = 'Post has not been created.'
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post has been successfully updated.'
    else
      initialize_assocations
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
    @post = Post.friendly.find(params[:id])
  end

  def initialize_assocations
    (5 - @post.links.length).times { @post.links.new }
    @post.build_tag_list unless @post.tag_list
    @post.build_video unless @post.video
    (5 - @post.images.length).times { @post.images.new }
  end

  def post_params
    params.require(:post).permit(:content,
      links_attributes: %i[ id body _destroy ],
      tag_list_attributes: %i[ id list _destroy ],
      video_attributes: %i[ id video remote_video _destroy ],
      images_attributes: %i[ id photo remote_photo _destroy ]
    )
  end

  def authorize_user
    if @post.user_id != current_user.id
      redirect_to @post, notice: 'You do not have permission to perform this operation.', status: :forbidden
    end
  end
end
