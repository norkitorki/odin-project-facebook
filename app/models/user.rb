require 'carrierwave/orm/activerecord'

class User < ApplicationRecord
  extend FriendlyId

  mount_uploader :photo, PhotoUploader

  include Gravtastic
  gravtastic secure: true,
             filetype: :jpg,
             size: 150

  friendly_id :full_name, use: :slugged

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, :first_name, :last_name, :birthday, presence: true
  validates :email, uniqueness: true, format: Devise.email_regexp

  validate :validate_photo_size

  has_many :friendships
  has_many :friends, through: :friendships,
    dependent: :destroy

  has_many :friend_requests,
    dependent: :destroy

  has_many :pending_friend_requests,
    class_name: 'FriendRequest',
    foreign_key: :candidate_id

  has_many :posts,
    dependent: :destroy

  has_many :comments,
    dependent: :destroy

  has_many :likes,
    dependent: :destroy

  has_many :notifications,
    dependent: :destroy

  def full_name
    "#{first_name} #{last_name}"
  end

  def friend?(user)
    friendships.exists?(friend: user)
  end

  def friend_request?(user)
    friend_requests.exists?(candidate: user)
  end

  def normalize_friendly_id(string)
    super.gsub("-", "_")
  end

  private

  def validate_photo_size
    errors.add(:photo, 'exceeds the maximum file size of 3MB') if photo.size > 3.megabytes
  end
end
