# app/models/user_storage.rb

require 'singleton'

class UserStorage
  include Singleton

  def initialize
    @users = {}
  end

  def add_user(user)
    @users[user.id] = user
  end

  def update_user(user)
    @users[user.id] = user if @users.key?(user.id)
  end

  def find_user(id)
    @users[id]
  end

  def all_users
    @users.values
  end

  def delete_user(id)
    @users.delete(id)
  end
end