module ApplicationHelper
  private

  def generate_uuid
    SecureRandom.urlsafe_base64
  end
end
