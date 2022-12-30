class Attachment < ApplicationRecord
  extend FriendlyId

  include ApplicationHelper

  mount_uploader :photo, PhotoUploader
  mount_uploader :video, VideoUploader

  friendly_id :generate_uuid, use: :slugged

  belongs_to :attachable, polymorphic: true

  def photo?
    !photo_url.empty? && !remove_photo
  end

  def video?
    video_url && !remove_video
  end
end
