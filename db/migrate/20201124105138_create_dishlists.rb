class CreateDishlists < ActiveRecord::Migration[6.0]
  def change
    create_table :dishlists do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.boolean :public, default: true

      t.timestamps
    end
  end
end
