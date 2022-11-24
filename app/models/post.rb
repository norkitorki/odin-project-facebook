class Post < ApplicationRecord
  belongs_to :user

  validates :content, presence: true

  has_many :comments, as: :commentable,
    dependent: :destroy

  has_many :likes, as: :likeable,
  dependent: :destroy

  def edited?
    created_at < updated_at
  end

  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end
end
