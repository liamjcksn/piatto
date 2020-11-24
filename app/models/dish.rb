class Dish < ApplicationRecord
  belongs_to :restaurant
  has_many :dishlist_dishes
  has_many :dishlists, through: :dishlist_dishes
  has_many :reviews
end
