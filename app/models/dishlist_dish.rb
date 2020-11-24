class DishlistDish < ApplicationRecord
  belongs_to :dish
  belongs_to :dishlist
end
