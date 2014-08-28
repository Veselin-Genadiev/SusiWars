class Question
  include DataMapper::Resource

  property :id, Serial
  property :question, String
  property :first_answer, String
  property :second_answer, String
  property :third_answer, String
  property :fourth_answer, String
  property :correct_answer, String

  has n, :games, through: Resource

  def self.correct_answered(question_id, answer)
    Question.first(id: question_id).correct_answer == answer
  end

  def self.question(question, first_answer, second_anser, third_answer,
                    fourth_answer, correct_answer)
    Question.first_or_create({ question: question,
                               first_answer: first_answer,
                               second_answer: second_answer,
                               third_answer: third_answer,
                               fourth_answer: fourth_answer,
                               correct_answer: correct_answer })
  end
end
