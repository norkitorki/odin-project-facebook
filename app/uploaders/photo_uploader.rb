class PhotoUploader < CarrierWave::Uploader::Base
  include UploaderHelper

  storage :file

  def default_url(*args)
    case model.class.to_s
    when 'Attachment' then model.remote_photo || ''
    when 'User' then model.gravatar_url
    end
  end

  def content_type_allowlist
    /image\//
  end

  def size_range
    1.byte..3.megabytes
  end
end
