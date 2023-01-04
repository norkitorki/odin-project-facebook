class PhotoUploader < CarrierWave::Uploader::Base
  include UploaderHelper

  storage :file

  def default_url(*args)
    model.respond_to?(:remote_photo) ? model.remote_photo.to_s : ''
  end

  def content_type_allowlist
    /image\//
  end

  def size_range
    1.byte..3.megabytes
  end
end
