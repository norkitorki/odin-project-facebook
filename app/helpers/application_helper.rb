module ApplicationHelper
  private

  def generate_uuid
    SecureRandom.hex(16)
  end
end
