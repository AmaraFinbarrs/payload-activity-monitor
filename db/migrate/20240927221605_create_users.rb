# Users
class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.integer :consecutive_withdrawals
      t.integer :asc_deposit_count
      t.integer :current_deposit
      t.integer :deposit_30s_sum
      t.datetime :deposit_30s_start_time

      t.timestamps
    end
  end
end
