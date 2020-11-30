class AddAverageRatingToDish < ActiveRecord::Migration[6.0]
  def change
    add_column :dishes, :average_rating, :float
  end
end
