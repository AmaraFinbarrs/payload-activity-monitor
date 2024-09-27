# config/initializers/users.rb
# Load the User in-memory storage

require_relative '../../app/models/user_storage'

Users = UserStorage.instance
