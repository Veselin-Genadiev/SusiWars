class User
  include DataMapper::Resource

  property :id, Serial
  property :username, String
  property :permission, Enum[:user, :admin, :bash_admin], default: :user
  property :score, Integer

  belongs_to :game, required: false

  def add_win
    self.score += 2
    self.save
    self
  end

  def add_draw
    self.score += 1
    self.save
    self
  end

  def self.user(username)
    User.first_or_create({ username: username },
                         { permission: :user, score: 0 })
  end

  def self.admin(username)
    @user = User.first_or_create({ username: username },
                                 {permission: :admin, score: 0 })
    @user.update(permission: :admin)
    @user
  end

  def self.bash_admin(username)
    @user = User.first_or_create({ username: username },
                                 { permission: :bash_admin, score: 0 })
    @user.update(permission: :bash_admin)
    @user
  end

  def self.users
    User.all(permission: :user)
  end

  def self.admins
    User.all(permission: :admin)
  end

  def self.bash_admins
    User.all(permission: :bash_admin)
  end
end
