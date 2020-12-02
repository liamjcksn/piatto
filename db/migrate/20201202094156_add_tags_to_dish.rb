class AddTagsToDish < ActiveRecord::Migration[6.0]
  def change
    add_column :dishes, :tags, :string
  end
end
