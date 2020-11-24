class Dishlist < ApplicationRecord
  belongs_to :user
  has_many :dishlist_dishes
  has_many :dishes, through: :dishlist_dishes
end
