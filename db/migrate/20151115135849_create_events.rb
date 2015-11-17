class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :friend_id
      t.string :name
      t.string :image_url
      t.integer :count
      t.timestamps null: false
    end
    add_index :events, [:friend_id, :name]
  end
end
