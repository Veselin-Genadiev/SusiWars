class Question
  include DataMapper::Resource

  property :id, Serial
  property :question, String
  property :first_answer, String
  property :second_answer, String
  property :third_answer, String
  property :fourth_answer, String
  property :correct_answer, String
end
