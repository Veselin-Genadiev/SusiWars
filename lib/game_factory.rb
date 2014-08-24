require_relative 'user_factory'

class GameFactory
  def self.create_game(first_user_name, second_user_name)
    @questions = Question.all.sample(5)
    @first_user = UserFactory.get_user(first_user_name)
    @second_user = UserFactory.get_user(second_user_name)
    @users = [@first_user, @second_user]
    Game.create(questions: @questions, users: @users)
  end
end
