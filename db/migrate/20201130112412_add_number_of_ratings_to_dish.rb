class AddNumberOfRatingsToDish < ActiveRecord::Migration[6.0]
  def change
    add_column :dishes, :reviews_count, :integer, { default: 0 }
  end
end
