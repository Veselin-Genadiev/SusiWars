require File.expand_path '../spec_helper.rb', __FILE__

describe 'SusiWars' do
  it 'should allow accessing the home page' do
    get '/'
    last_response.should be_ok
  end

  it 'shouldn\'t have "username" and "key" cookies on logout' do
    #post '/logout'
  end
end