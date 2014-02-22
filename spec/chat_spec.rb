require File.expand_path '../spec_helper.rb', __FILE__

describe 'Chat' do
  before_adding_message = nil

  it 'should read chat successfully' do
    before_adding_message = post '/read'
    last_response.should be_ok
  end

  it 'should successfully add message' do
    message = {'msg' => 'whatever'}
    post '/write', message
    last_response.should.eql? message['msg']
  end

  it 'should have only one message in advance after "/write" post' do
    post '/read'
    last_response.should.eql? before_adding_message.body + '\nwhatever'
  end
end