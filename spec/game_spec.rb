require_relative 'spec_helper'

describe Game do
  before :each do
    @users = (1..2).map { |number| User.user("User#{number}") }
    @questions = (1..5).map { |number| Question.question("q1 #{number}",
                                                         "a1 #{number}",
                                                         "a2 #{number}",
                                                         "a3 #{number}",
                                                         "a4 #{number}",
                                                         "a4 #{number}") }
  end

  it 'Creates game that is open' do
    @game = Game.create_game(@users.first.username)
    expect(@game.state).to eq(:open)
    expect(Game.open_games).to include(@game)
  end

  it 'Successfull joins a game' do
    @game = Game.create_game(@users.first.username)
    @game = Game.join_game(@game.id, @users.last.username)
    expect(@game.state).to eq(:closed)
    expect(Game.open_games).not_to include(@game)
  end

  it 'Lists all open games' do
    @first_game = Game.create_game(@users.first.username)
    @second_game = Game.create_game(@users.last.username)
    expect(Game.open_games).to eq([@first_game, @second_game])
  end

  it 'Updates game result' do
    @game = Game.create_game(@users.first.username)
    @game = Game.join_game(@game.id, @users.last.username)
    @game = Game.update_result(@game.id, @users.last.username)
    expect(@game.result).to eq(1)
  end

  it 'Doesnt update open/finished game result' do
    @game = Game.create_game(@users.first.username)
    @game = Game.update_result(@game.id, @users.first.username)
    expect(@game.result).to eq(0)
    @game = Game.join_game(@game.id, @users.last.username)
    @game = Game.update_users_score(@game.id)
    @game = Game.update_result(@game.id, @users.last.username)
    expect(@game.result).to eq(0)
  end

  it 'Updates user score on draw' do
    @game = Game.create_game(@users.first.username)
    @game = Game.join_game(@game.id, @users.last.username)
    @old_scores = [@users.first.score, @users.last.score]
    @game = Game.update_users_score(@game.id)
    @new_scores = [User.user(@users.first.username).score,
                   User.user(@users.last.username).score]
    expect(@new_scores).to eq(@old_scores.map { |score| score + 1 })
  end

  it 'Updates user score on win' do
    @game = Game.create_game(@users.first.username)
    @game = Game.join_game(@game.id, @users.last.username)
    @game = Game.update_result(@game.id, @users.last.username)
    @old_user_score = @users.last.score
    @game = Game.update_users_score(@game.id)
    expect(User.user(@users.last.username).score).to eq(@old_user_score + 2)
  end

  it 'Doesnt update open/finished user score' do
    @game = Game.create_game(@users.first.username)
    @game = Game.join_game(@game.id, @users.last.username)
    @game = Game.update_result(@game.id, @users.first.username)
    @old_score = @users.first.score
    @game = Game.update_users_score(@game.id)
    expect(User.user(@users.first.username).score).to eq(@old_score + 2)
    @old_score = User.user(@users.first.username).score
    @game = Game.update_users_score(@game.id)
    expect(User.user(@users.first.username).score).to eq(@old_score)
  end
end
