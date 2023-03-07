class TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_page, only: :show

  def index
    unique_tags = TagList.all.map(&:to_a).flatten.uniq
    @tags       = tags_by_first_letter(unique_tags)
  end

  def show
    @tag   = params[:s]
    posts  = Post.find_by_tag(@tag).includes(:comments, :images, :likes, :links, :tag_list, :user, :video)
    @posts = resource_pagination(posts, @page, 15)
  end

  private

  def tags_by_first_letter(tags)
    tags.each_with_object({}) do |tag, hash|
      first_letter = tag[0].downcase
      hash[first_letter] ||= []
      hash[first_letter] << tag.downcase
    end.sort
  end
end
