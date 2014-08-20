require 'user'

class UserFactory
  def self.new_user(user_name)
    User.create(user_name: user_name, permission: 'user', score: 0)
  end

  def self.new_admin(user_name)
    User.create(user_name: user_name, permission: 'admin', score: 0)
  end

  def self.new_bash_admin(user_name)
    User.create(user_name: user_name, permission: 'bash_admin', score: 0)
  end

  def self.get_user(user_name)
    User.get(user_name: user_name)
  end
end
