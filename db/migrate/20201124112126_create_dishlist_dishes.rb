class CreateDishlistDishes < ActiveRecord::Migration[6.0]
  def change
    create_table :dishlist_dishes do |t|
      t.references :dish, null: false, foreign_key: true
      t.references :dishlist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
