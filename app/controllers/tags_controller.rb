class TagsController < ApplicationController
  before_action :authenticate_user!

  def show
    @objects = TagList.tagables(params[:s])
  end
end
