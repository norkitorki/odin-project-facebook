class Comment < ApplicationRecord
  include LikesHelper

  validates :body, presence: true

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  has_many :likes, as: :likeable,
    dependent: :destroy

  has_many :replies, class_name: 'Comment', foreign_key: :parent_id,
    dependent: :destroy

  def edited?
    created_at < updated_at
  end
end
