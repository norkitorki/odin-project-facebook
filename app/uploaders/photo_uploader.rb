class PhotoUploader < CarrierWave::Uploader::Base
  include UploaderHelper

  storage :file

  def default_url(*args)
    remote_photo = model.remote_photo
    case model.attachable_type
    when 'Post' then remote_photo || ''
    when 'User' then user_photo(remote_photo)
    else ''
    end
  end

  def content_type_allowlist
    /image\//
  end

  def size_range
    1.byte..3.megabytes
  end

  private

  def user_photo(remote_photo)
    [nil, ''].none?(remote_photo) ? remote_photo : model.attachable.gravatar_url
  end
end
