require 'carrierwave/orm/activerecord'

class Post < ApplicationRecord
  extend FriendlyId

  mount_uploader :photo, PhotoUploader

  include ApplicationHelper
  include LikesHelper

  friendly_id :generate_uuid, use: :slugged

  belongs_to :user

  validates :content, presence: true, unless: :photo_only?

  has_many :comments, as: :commentable,
    dependent: :destroy

  has_many :likes, as: :likeable,
    dependent: :destroy

  has_many :links, as: :linkable,
    dependent: :destroy

  has_one :tag_list, as: :tagable,
    dependent: :destroy

  accepts_nested_attributes_for :links,
    allow_destroy: true,
    reject_if: :all_blank

  accepts_nested_attributes_for :tag_list,
    allow_destroy: true,
    reject_if: :all_blank

  def edited?
    created_at < updated_at
  end

  private

  def photo_only?
    content.empty? && (photo.file && !remove_photo || !remote_photo.empty?)
  end
end
