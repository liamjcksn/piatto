class Dishlist < ApplicationRecord
  belongs_to :user
  has_many :dishlist_dishes, dependent: :destroy
  has_many :dishes, through: :dishlist_dishes
  has_one_attached :photo
end
