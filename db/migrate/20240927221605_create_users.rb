# Users
class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.integer :consecutive_withdrawals, default: 0
      t.integer :asc_deposit_count, default: 0
      t.integer :current_deposit, default: 0
      t.integer :deposit_30s_sum, default: 0
      t.datetime :deposit_30s_start_time, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end
  end
end
