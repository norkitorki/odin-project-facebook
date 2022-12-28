class TagsController < ApplicationController
  before_action :authenticate_user!

  def show
    @objects = TagList.find_by_tag(params[:s])
  end
end
