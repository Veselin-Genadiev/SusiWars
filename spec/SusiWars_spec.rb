require_relative 'spec_helper'

describe SusiWars::App do
  include Rack::Test::Methods
  include OutputHelper

  def app
    SusiWars::App.new
  end

  before :all do
    clear_cookies
  end

  before :each do
    set_cookie 'game=none'
    user_info = '{"doesnt_realy": "matter"}' #{firstName: "Веселин", lastName: "Генадиев"}.to_json
    set_cookie "user_info=#{user_info}"
    set_cookie 'username=vgenadiev'
    User.user('vgenadiev')
    User.user('toshko')
    User.user('pesho')
    User.user('gosho')
    Question.question('Question 1',
                      'Answer 1',
                      'Answer 2',
                      'Answer 3',
                      'Answer 4',
                      'Answer 3')

    @first_game = Game.create_game('vgenadiev')
    @second_game = Game.create_game('pesho')
  end

  it 'Should show default index page' do
    get '/'
    expect(last_response).to be_ok
  end

  it 'Should show login screen when there are no cookies' do
    clear_cookies
    get '/'
    expect(last_response.body).to include(verification_tag(:login))
  end

  it 'Should show index page when there are cookies' do
    get '/'
    expect(last_response.body).to include(verification_tag(:index))
  end

  it 'Should show login screen when invalid data is passed to login form' do
    clear_cookies
    post '/login', params={login: 'baba', password: 'vuna'}
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_response.body).to include(verification_tag(:login))
  end

  it 'Clears cookies on logout' do
    get '/logout'
    expect(rack_mock_session.cookie_jar['user_info']).to eq('')
    expect(rack_mock_session.cookie_jar['username']).to eq('')
    expect(rack_mock_session.cookie_jar['game']).to eq('')
  end

  it 'Shows admin adding page' do
    get '/'
    get '/admin'
    expect(last_response.body).to include(verification_tag(:admin))
  end

  it 'Adds admin successfully' do
    get '/'
    toshko = User.user('toshko')
    post '/admin', params={username: 'toshko'}
    expect(User.admins).to include(toshko)
  end

  it 'Doesnt show admin adding page for non bash_admin' do
    set_cookie 'username=hiphopami'
    get '/'
    get '/admin'
    expect(last_response.body).not_to include(verification_tag(:admin))
  end

  it 'Shows question adding page' do
    get '/'
    get '/question'
    expect(last_response.body).to include(verification_tag(:question))
  end

  it 'Adds question successfully' do
    get '/'
    post '/question', params={ question: 'Question',
                               first_answer: 'Answer1',
                               second_answer: 'Answer2',
                               third_answer: 'Answer3',
                               fourth_answer: 'Answer4',
                               correct_answer: 'Answer3' }

    expect(Question.all).to include(Question.question('Question',
                                                      'Answer1',
                                                      'Answer2',
                                                      'Answer3',
                                                      'Answer4',
                                                      'Answer3'))
  end

  it 'Doesnt show qustion adding page for non admin' do
    set_cookie 'username=hiphopami'
    get '/'
    get '/admin'
    expect(last_response.body).not_to include(verification_tag(:question))
  end

  it 'Lists all open games games successful' do
    get '/game_list'
    @games = JSON.parse(last_response.body).map { |game| Game.first(id: game['id']) }
    expect(@games).to eq([@first_game, @second_game])
  end

  it 'Doesnt list closed/finished games' do
    @first_game = Game.join_game(@first_game.id, 'toshko')
    @first_game = Game.update_users_score(@first_game.id)
    @second_game = Game.join_game(@second_game.id, 'gosho')
    get '/game_list'
    @games = JSON.parse(last_response.body).map { |game| Game.first(id: game['id']) }
    expect(@games).to eq([])
  end

  it 'Shows game creating/joining page and changes state to closed on join' do
    get '/'
    get '/game'
    expect(last_response.body).to include(verification_tag(:game))
    @game = Game.first(users: [User.user('vgenadiev')], state: :open)
    set_cookie 'username=toshko'
    get '/'
    get '/game', params={id: @game.id}
    expect(last_response.body).to include(verification_tag(:game))
    @game = Game.first(id: @game.id)
    expect(@game.state).to eq(:closed)
  end

  it 'Updates game result on correct answer' do
    @game = Game.create_game('vgenadiev')
    @game = Game.join_game(@game.id, 'toshko')
    @question = @game.questions.first
    post '/answer', params={id: @game.id, question_id: @question.id,
                            answer: @question.correct_answer}
    @game = Game.first(id: @game.id)
    expect(@game.result).to eq(-1)
  end

  it 'Doesnt update game result on incorrect answer' do
    @game = Game.create_game('vgenadiev')
    @game = Game.join_game(@game.id, 'toshko')
    @question = @game.questions.first
    post '/answer', params={id: @game.id, question_id: @question.id,
                            answer: @question.first_answer}
    @game = Game.first(id: @game.id)
    expect(@game.result).to eq(0)
  end

  it 'Updates user score on draw/win' do
    @first_game = Game.join_game(@first_game.id, 'toshko')
    @second_game = Game.join_game(@second_game.id, 'gosho')
    @question = @first_game.questions.first
    post '/answer', params={id: @first_game.id, question_id: @question.id,
                            answer: @question.correct_answer}
    post '/game', params={id: @first_game.id}
    @vesko = User.user('vgenadiev')
    expect(@vesko.score).to eq(2)

    post '/game', params={id: @second_game.id}
    @pesho = User.user('pesho')
    @gosho = User.user('gosho')
    expect(@pesho.score).to eq(1)
    expect(@gosho.score).to eq(1)
  end
end
