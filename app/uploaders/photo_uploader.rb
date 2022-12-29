class PhotoUploader < CarrierWave::Uploader::Base
  include UploaderHelper

  storage :file

  def default_url(*args)
    case model.class.to_s
    when 'Post' then model.remote_photo || ''
    when 'User' then model.gravatar_url
    end
  end

  def extension_allowlist
    %w[ jpg jpeg gif png ]
  end
end
