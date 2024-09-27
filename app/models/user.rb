# app/model/user.rb
class User
  include ActiveModel::API
  include ActiveModel::Attributes

  # Defining attributes
  attribute :id, :integer
  attribute :consecutive_withdrawals, :integer, default: 0
  attribute :asc_deposit_count, :integer, default: 0
  attribute :current_deposit, :integer, default: 0
  attribute :deposit_30s_sum, :integer, default: 0
  attribute :deposit_30s_start_time, :datetime, default: -> { Time.now }

  validates :id, :asc_deposit_count, :deposit_30s_sum, presence: true

  def create
    Users.add_user(self)
  end

  def update
    Users.update_user(self)
  end

end
