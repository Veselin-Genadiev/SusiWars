require_relative 'spec_helper'

describe Question do
  before :each do
    @question = Question.question('Which of the below is a good part of PHP?',
                                  'Crap code',
                                  'Crap codewriters',
                                  'Crap design',
                                  'None of these',
                                  'None of these')
  end

  it 'should be valid' do
    expect(@question).to be_valid
  end

  it 'should accept correct answer' do
    @answer_response = Question.correct_answered(@question.id, @question.correct_answer)
    expect(@answer_response).to be true
  end

  it 'should not accept incorrect answer' do
    @answer_response = Question.correct_answered(@question.id, @question.first_answer)
    expect(@answer_response).to be false
  end
end
