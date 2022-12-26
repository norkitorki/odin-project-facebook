class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :body, presence: true

end
