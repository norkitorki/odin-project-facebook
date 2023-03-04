class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, except: %i[ new create ]

  def show
    redirect_to [@comment.commentable, anchor: @comment.friendly_id], status: :see_other
  end

  def new
    @comment             = Comment.new(parent: params[:parent])
    @comment.commentable = @comment.ancestor&.commentable
    @commentable         = @comment.commentable
  end

  def edit
  end

  def create
    @comment     = current_user.comments.new(comment_params)
    @commentable = @comment.commentable

    if @comment.save
      redirect_to polymorphic_url(@commentable, anchor: @comment.slug), notice: 'Comment has been successfully created.'
    else
      flash.now[:alert] = 'Comment has not been created.'
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to @comment.commentable, notice: 'Comment has been successfully updated.'
    else
      set_comment
      flash.now[:alert] = 'Comment has not been updated.'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to @comment.commentable, alert: 'Comment has been deleted.'
  end

  private

  def set_comment
    @comment = Comment.friendly.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :parent, commentable_params)
  end

  def commentable_params
    %i[ commentable_type commentable_id ]
  end
end
