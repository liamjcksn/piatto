class AddJustEatDishIdToDishes < ActiveRecord::Migration[6.0]
  def change
    add_column :dishes, :just_eat_dish_id, :integer
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
