class VideoUploader < CarrierWave::Uploader::Base
  include UploaderHelper

  storage :file

  def extension_allowlist
    %w[ avi mkv mov mp4 webm ]
  end
end
