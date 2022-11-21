class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, except: :create

  def edit
  end

  def create
    @comment = current_user.comments.new(comment_params)

    if @comment.save
      redirect_to @comment.commentable, notice: 'Comment has been successfully created.'
    else
      flash.now[:alert] = 'Comment has not been created.'
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to @comment.commentable
    else
      flash.now[:alert] = 'Comment has not been updated.'
    end
  end

  def destroy
    @comment.destroy
    redirect_to @comment.commentable
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :commentable_type, :commentable_id)
  end
end
