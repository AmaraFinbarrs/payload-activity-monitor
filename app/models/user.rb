# app/model/user.rb
class User < ApplicationRecord
  validates :id, presence: true

  attribute :consecutive_withdrawals, :integer, default: 0
  attribute :asc_deposit_count, :integer, default: 0
  attribute :current_deposit, :integer, default: 0
  attribute :deposit_30s_sum, :integer, default: 0
  attribute :deposit_30s_start_time, :datetime, default: -> { Time.current }
end
