class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :oauth_token, :string
    add_column :users, :oauth_token_secret, :string
    add_index :users, :username, unique: true
  end
end
