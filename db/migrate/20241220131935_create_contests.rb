class CreateContests < ActiveRecord::Migration[7.2]
  def change
    create_table :contests do |t|
      t.integer :user_id
      t.string :url

      t.timestamps
    end
  end
end
