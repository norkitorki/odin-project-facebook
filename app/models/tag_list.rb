class TagList < ApplicationRecord
  before_save { self.list = format_list.join(',') }

  belongs_to :tagable, polymorphic: true

  validates :list, format: {
    with: /\A[a-zA-Z0-9, ]+\z/,
    message: 'of tags must be comma seperated and consist only of alphabetic letters(a-z) and numbers(0-9)'
    }

  validate :validate_tag_count

  def self.find_by_tag(tag)
    where("list LIKE ?", "%#{sanitize_sql_like(tag)}%").map(&:tagable)
  end

  def to_a
    list.split(',')
  end

  private

  def format_list
    list.downcase.gsub(' ', '').split(',').uniq.sort
  end

  def validate_tag_count(max = 10)
    errors.add(:list, "cannot have more than #{max} tags") if format_list.length > max
  end
end
