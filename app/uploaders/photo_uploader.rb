class PhotoUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    model_id = model.respond_to?(:slug) ? model.slug : model.id
    "uploads/#{model.class.to_s.downcase}/#{model_id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url(*args)
    case model.class.to_s
    when 'Post' then model.remote_photo || ''
    when 'User' then model.gravatar_url
    end
  end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add an allowlist of extensions which are allowed to be uploaded.
  def extension_allowlist
    %w[ jpg jpeg gif png ]
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    if original_filename
      filetype = original_filename.split('.').last
      @string ||= "#{SecureRandom.urlsafe_base64}.#{filetype}"
    end
  end
end
