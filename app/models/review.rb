class Review < ApplicationRecord
  belongs_to :user
  belongs_to :dish
  has_many_attached :images
  validates :rating, presence: true
end
