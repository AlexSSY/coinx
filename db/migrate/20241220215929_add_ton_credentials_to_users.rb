class AddTonCredentialsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :ton_private, :string
    add_column :users, :ton_public, :string
    add_column :users, :ton_address, :string
  end
end
