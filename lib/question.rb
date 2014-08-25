class Question
  include DataMapper::Resource

  property :id, Serial
  property :question, String
  property :first_answer, String
  property :second_answer, String
  property :third_answer, String
  property :fourth_answer, String
  property :correct_answer, String

  belongs_to :game, required: false

  def question(question, first_answer, second_anser, third_answer,
               fourth_answer, correct_answer)
    Question.first_or_create({ question: params[:question],
                               first_answer: params[:first_answer],
                               second_answer: params[:second_answer],
                               third_answer: params[:third_answer],
                               fourth_answer: params[:fourth_answer],
                               correct_answer: params[:correct_answer] })
  end
end
