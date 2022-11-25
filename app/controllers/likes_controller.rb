class LikesController < ApplicationController
  before_action :authenticate_user!, :set_path

  def create
    @like = current_user.likes.new(likeable_params)
    @likeable = @like.likeable

    if @like.save
      redirect_to @path, notice: "#{@likeable.class} has been liked."
    else
      redirect_to @path, alert: "#{@likeable.class} has not been liked."
    end
  end

  def destroy
    @like = Like.find(params[:id])
    @like.destroy

    redirect_to @path, alert: "#{@like.likeable.class} has been unliked."
  end

  private

  def likeable_params
    params.require(:likeable).permit(:likeable_type, :likeable_id)
  end

  def set_path
    @path = params[:path] || root_path
  end
end