class CreateEventDictionaries < ActiveRecord::Migration
  def change
    create_table :event_dictionaries do |t|
      t.string :text
      t.integer :count
      t.timestamps null: false
    end
  end
end
