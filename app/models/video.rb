require 'carrierwave/orm/activerecord'

class Video < ApplicationRecord
  extend FriendlyId

  include ApplicationHelper

  friendly_id :generate_uuid, use: :slugged

  mount_uploader :video, VideoUploader

  belongs_to :videoable, polymorphic: true

  def to_s
    video_url
  end

  def video_present?
    video.file || [nil, ''].none?(remote_video)
  end
end
