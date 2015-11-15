class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.string :username, null: false
      t.string :status, null: false, default: "analyzing"
      t.timestamps null: false
    end
  end
end
