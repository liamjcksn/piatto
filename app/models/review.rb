class Review < ApplicationRecord
  belongs_to :user
  belongs_to :dish
  validates :rating, presence: true
  has_many_attached :photos
end
