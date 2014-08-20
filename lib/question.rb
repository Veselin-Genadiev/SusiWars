class Question
  include DataMapper::Resource

  property :id, Serial
  property :first_answer, String
  property :second_answer, String
  property :third_answer, String
  property :fourth_answer, String
  property :correct_answer, String

  belongs_to :game
end
