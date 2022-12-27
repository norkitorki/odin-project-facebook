class TagList < ApplicationRecord
  belongs_to :tagable, polymorphic: true
end
