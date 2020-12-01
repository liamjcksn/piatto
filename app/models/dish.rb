class Dish < ApplicationRecord
  belongs_to :restaurant
  has_many :dishlist_dishes
  has_many :dishlists, through: :dishlist_dishes
  has_many :reviews
  

  include PgSearch::Model
  pg_search_scope :search_by_dish,
                  against: [:name, :description],
                  # associated_against: {
                  #   restaurant: [:name]
                  # },
                  using: {
                    tsearch: { prefix: true } # <-- now `superman batm` will return something!
                  }
end
