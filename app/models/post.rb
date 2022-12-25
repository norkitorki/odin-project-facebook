require 'carrierwave/orm/activerecord'

class Post < ApplicationRecord
  extend FriendlyId

  mount_uploader :photo, PhotoUploader

  include ApplicationHelper
  include LikesHelper

  friendly_id :generate_uuid, use: :slugged

  belongs_to :user

  validates :content, presence: true

  has_many :comments, as: :commentable,
    dependent: :destroy

  has_many :likes, as: :likeable,
    dependent: :destroy

  def edited?
    created_at < updated_at
  end

  private

  def photo_only?
    content.empty? && (photo.file && !remove_photo || !remote_photo.empty?)
  end
end
