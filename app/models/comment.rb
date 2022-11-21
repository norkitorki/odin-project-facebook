class Comment < ApplicationRecord
  validates :body, presence: true

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  has_many :likes, as: :likeable

  def edited?
    created_at < updated_at
  end
end
