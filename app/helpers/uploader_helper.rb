module UploaderHelper
  def filename
    if original_filename
      filetype = original_filename.split('.').last
      @string ||= "#{SecureRandom.urlsafe_base64}.#{filetype}"
    end
  end

  private

  def store_dir
    model_id = model.respond_to?(:slug) ? model.slug : model.id
    "uploads/#{model.class.to_s.downcase}/#{model_id}"
  end
end