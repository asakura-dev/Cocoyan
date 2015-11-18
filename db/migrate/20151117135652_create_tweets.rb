class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :event_id
      t.string :text
      t.string :url
      t.time :time
      t.timestamps null: false
    end
  end
end
