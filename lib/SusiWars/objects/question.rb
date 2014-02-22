class Question
  attr_writer :question, :answer_one, :answer_two,
  attr_writer :answer_three, :answer_four, :correct_answer_index

  def initialize(options = {})
    @question = options[:question]
    @answer_one = options[:answer_one]
    @answer_two = options[:answer_two]
    @answer_three = options[:answer_three]
    @answer_four = options[:answer_four]
    @correct_answer_index = options[:correct_answer_index]
  end
end