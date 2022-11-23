class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @like = current_user.likes.new(like_params)
    likeable_class = @like.likeable.class

    if @like.save
      flash.now[:notice] = "#{likeable_class} has been liked."
    else
      flash.now[:alert] = "#{likeable_class} has not been liked."
    end
  end

  def destroy
    @like = Like.find(params[:id])
    @like.destroy
  end

  private

  def like_params
    params.require(:like).permit(:likeable_type, :likeable_id)
  end
end
