class TagsController < ApplicationController
  before_action :authenticate_user!

  def show
    @tag   = params[:s]
    @posts = TagList.find_by_tag(@tag)
  end

  private

  def tags_by_first_letter(tags)
    tags.each_with_object({}) do |tag, hash|
      first_letter = tag[0].upcase
      hash[first_letter] ||= []
      hash[first_letter] << tag.downcase
    end.sort
  end
end
