class Post < ApplicationRecord
  extend FriendlyId

  include ApplicationHelper
  include LikesHelper

  friendly_id :generate_uuid, use: :slugged

  belongs_to :user

  validates :content, presence: true, unless: :attachment_only?

  has_many :comments, as: :commentable,
    dependent: :destroy

  has_many :likes, as: :likeable,
    dependent: :destroy

  has_many :links, as: :linkable,
    dependent: :destroy

  has_one :tag_list, as: :tagable,
    dependent: :destroy

  has_one :attachment, as: :attachable,
    dependent: :destroy

  has_many :images, as: :imageable,
    dependent: :destroy

  accepts_nested_attributes_for :links,
    allow_destroy: true,
    reject_if: :all_blank

  accepts_nested_attributes_for :tag_list,
    allow_destroy: true,
    reject_if: :all_blank

  accepts_nested_attributes_for :attachment

  accepts_nested_attributes_for :images,
    allow_destroy: true,
    reject_if: :all_blank

  def edited?
    created_at < updated_at
  end

  private

  def attachment_only?
    content.empty? && (attachment.photo? || attachment.video?)
  end
end
