class CreateFollowings < ActiveRecord::Migration[6.0]
  def change
    create_table :followings do |t|
      t.references :follower, foreign_key: { to_table: 'users' }
      t.references :followee, foreign_key: { to_table: 'users' }

      t.timestamps
    end
  end
end
