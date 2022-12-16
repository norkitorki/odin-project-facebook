class Comment < ApplicationRecord
  extend FriendlyId

  include ApplicationHelper
  include LikesHelper

  friendly_id :generate_uuid, use: :slugged

  scope :root, -> { where(parent: '') }

  validates :body, presence: true

  belongs_to :user
  belongs_to :commentable, polymorphic: true
  belongs_to :ancestor, class_name: 'Comment',
    optional: true,
    foreign_key: :parent,
    primary_key: :slug,
    inverse_of: :replies 

  has_many :likes, as: :likeable,
    dependent: :destroy

  has_many :replies, class_name: 'Comment',
    foreign_key: :parent,
    primary_key: :slug,
    dependent: :destroy,
    inverse_of: :ancestor 

  def edited?
    created_at < updated_at
  end

  def collect_replies(comments = self.replies)
    comments.map { |comment| [comment, collect_replies(comment.replies)] }.to_h
  end
end
