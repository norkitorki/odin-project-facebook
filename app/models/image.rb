require 'carrierwave/orm/activerecord'

class Image < ApplicationRecord
  extend FriendlyId
  
  include ApplicationHelper

  friendly_id :generate_uuid, use: :slugged

  mount_uploader :photo, PhotoUploader

  belongs_to :imageable, polymorphic: true

  def to_s
    photo_url
  end

  def image_present?
    !photo.file.nil? || [nil, ''].none?(remote_photo)
  end
end
