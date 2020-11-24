class CreateRestaurants < ActiveRecord::Migration[6.0]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.float :latitude
      t.float :longitude
      t.integer :just_eat_id
      t.string :url
      t.string :logourl
      t.string :postcode

      t.timestamps
    end
  end
end
