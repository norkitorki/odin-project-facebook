class VideoUploader < CarrierWave::Uploader::Base
  include UploaderHelper

  storage :file

  def extension_allowlist
    %w[ avi mkv mov mp4 webm ]
  end

  def size_range
    1.byte..10.megabytes
  end
end
