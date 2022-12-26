class Link < ApplicationRecord
  before_save :prepend_protocol

  belongs_to :linkable, polymorphic: true

  validates :body, 
    presence: true,
    format: {
      with: /\A(https?:\/{2})?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b[-a-zA-Z0-9@:%_\+.~#?&\/\/=]*\z/,
      message: 'must be a valid url'
    }

  private

  def prepend_protocol
    body.insert(0, 'http://') unless body.start_with?(/https?:\/\//)
  end
end
