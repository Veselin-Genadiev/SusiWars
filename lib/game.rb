class Game
  include DataMapper::Resource

  property :id, Serial
  property :state, Enum[:open, :closed], default: :open
  has n, :questions
  has n, :users

  def self.create_game(owner_name)
    @user = User.first(username: owner_name)
    @game = Game.create
    @game.users << @user
    Question.all.sample(5).each { |question| @game.questions << @question }
    @game.save
    @game
  end

  def self.join_game(id, guest_name)
    @game = Game.first(id: id)
    @game.users << User.first(username: guest_name)
    @game.save
    @game.update(state: :closed)
    @game
  end

  def self.open_games
    Game.all(state: :open).select { |game| game and game.users and game.users.count == 1 }
  end
end
