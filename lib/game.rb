class Game
  include DataMapper::Resource

  property :id, Serial
  property :state, Enum[:open, :closed, :finished], default: :open
  property :result, Integer, default: 0
  has n, :questions
  has n, :users

  def self.update_users_score(id)
    @game = Game.first(id: id)

    if @game.state == :finished or @game.state == :open
      return @game
    end

    if @game.result < 0
      @game.users.first.add_win
    elsif @game.result > 0
      @game.users.last.add_win
    else
      @game.users.each { |user| user.add_draw }
    end

    @game.update(state: :finished)
    @game
  end

  def self.update_result(id, username)
    @game = Game.first(id: id)

    if @game.state == :finished or @game.state == :open
      return @game
    end

    if username == @game.users.first.username
      @game.result -= 1
    elsif username == @game.users.last.username
      @game.result += 1
    end

    @game.save
    @game
  end

  def self.create_game(owner_name)
    @user = User.first(username: owner_name)
    Game.create(questions: Question.all.sample(5), users: [@user])
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
