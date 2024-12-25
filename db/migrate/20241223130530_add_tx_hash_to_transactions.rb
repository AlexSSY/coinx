class AddTxHashToTransactions < ActiveRecord::Migration[7.2]
  def change
    add_column :transactions, :tx_hash, :string
  end
end
