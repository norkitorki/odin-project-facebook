class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, :first_name, :last_name, :birthday, presence: true
  validates :email, uniqueness: true

  has_many :posts,
    dependent: :destroy

  has_many :comments,
    dependent: :destroy

  has_many :likes,
    dependent: :destroy
end
