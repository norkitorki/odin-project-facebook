class Post < ApplicationRecord
  extend FriendlyId

  include ApplicationHelper
  include LikesHelper

  friendly_id :generate_uuid, use: :slugged

  belongs_to :user

  validates :content, presence: true, unless: :media_only?

  has_one :tag_list, as: :tagable,
    dependent: :destroy

  has_one :video, as: :videoable,
    dependent: :destroy

  has_many :comments, as: :commentable,
    dependent: :destroy

  has_many :likes, as: :likeable,
    dependent: :destroy

  has_many :links, as: :linkable,
    dependent: :destroy

  has_many :images, as: :imageable,
    dependent: :destroy

  accepts_nested_attributes_for :links,
    allow_destroy: true,
    reject_if: :all_blank

  accepts_nested_attributes_for :tag_list,
    allow_destroy: true,
    reject_if: :all_blank

  accepts_nested_attributes_for :video,
    allow_destroy: true,
    reject_if: :all_blank

  accepts_nested_attributes_for :images,
    allow_destroy: true,
    reject_if: :all_blank

  def self.find_by_tag(tag)
    joins(:tag_list).where('tag_lists.list LIKE ?', "%,#{sanitize_sql_like(tag)},%")
  end

  def edited?
    created_at < updated_at
  end

  def all_images_destroyed?
    images.all?(&:_destroy)
  end

  private

  def media_only?
    (content.nil? || content.empty?) && (!all_images_destroyed? || video && video.video_present?)
  end
end
