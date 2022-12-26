class Link < ApplicationRecord
  before_save :prepend_protocol

  belongs_to :linkable, polymorphic: true

  validates :body, presence: true

  private

  def prepend_protocol
    body.insert(0, 'http://') unless body.start_with?(/https?:\/\//)
  end
end
