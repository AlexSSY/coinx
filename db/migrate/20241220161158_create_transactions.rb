class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.integer :user_id
      t.integer :tx_type
      t.string :sender
      t.string :receiver
      t.integer :assembly
      t.decimal :amount, precision: 20, scale: 10

      t.timestamps
    end
  end
end
