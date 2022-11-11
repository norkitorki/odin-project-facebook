class Post < ApplicationRecord
  belongs_to :user

  validates :content, presence: true

  has_many :comments, as: :commentable,
    dependent: :destroy

  has_many :likes, as: :likeable,
  dependent: :destroy
end