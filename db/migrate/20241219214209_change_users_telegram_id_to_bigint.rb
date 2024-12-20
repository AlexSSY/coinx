class ChangeUsersTelegramIdToBigint < ActiveRecord::Migration[7.2]
  def change
    change_column :users, :telegram_id, :bigint
  end
end
