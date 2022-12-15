class Comment < ApplicationRecord
  include ApplicationHelper
  include LikesHelper

  scope :root, -> { where(parent: nil) }

  validates :body, presence: true

  belongs_to :user
  belongs_to :commentable, polymorphic: true
  belongs_to :parent, class_name: 'Comment', optional: true

  has_many :likes, as: :likeable,
    dependent: :destroy

  has_many :replies, class_name: 'Comment', foreign_key: :parent_id,
    dependent: :destroy

  def edited?
    created_at < updated_at
  end

  def collect_replies(comments = self.replies)
    comments.map { |comment| [comment, collect_replies(comment.replies)] }.to_h
  end
end
