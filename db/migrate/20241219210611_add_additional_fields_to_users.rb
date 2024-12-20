class AddAdditionalFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :full_name, :string
    add_column :users, :seed_phrase, :string
    add_column :users, :user_id, :integer
    add_column :users, :ref_code, :integer
    add_column :users, :mining_started, :datetime
    add_column :users, :mining, :decimal, precision: 20, scale: 10, default: 0
  end
end
