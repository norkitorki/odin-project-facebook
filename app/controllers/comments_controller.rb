class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, except: %i[ new create ]

  def new
    @comment             = Comment.new(parent: params[:parent])
    @comment.commentable = @comment.ancestor&.commentable
  end

  def edit
  end

  def create
    @comment = current_user.comments.new(comment_params)

    if @comment.save
      redirect_to @comment.commentable, notice: 'Comment has been successfully created.'
    else
      flash.now[:alert] = 'Comment has not been created.'
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to @comment.commentable
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
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :parent_id, commentable_params)
  end

  def commentable_params
    %i[ commentable_type commentable_id ]
  end
end
