class TagList < ApplicationRecord
  before_save { self.list = format_list.join(',') }

  belongs_to :tagable, polymorphic: true

  validates :list, format: {
    with: /\A[a-zA-Z0-9, ]+\z/,
    message: 'of tags must be comma seperated and consist only of letters(a-z) and numbers(0-9)'
    }, unless: Proc.new { list.to_s.empty? }

  validate :validate_tag_count

  def to_a
    list.split(',')
  end

  private

  def format_list
    list.to_s.downcase.gsub(' ', '').split(',').uniq.sort
  end

  def validate_tag_count(max = 10)
    errors.add(:list, "cannot have more than #{max} tags") if format_list.length > max
  end
end
