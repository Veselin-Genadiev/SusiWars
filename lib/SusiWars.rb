require 'SusiWars/version'
require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'sqlite3'
require 'sequel'
require 'json'
require 'require_all'
require 'sinatra/sequel'

set :database, 'sqlite://SusiWars.db'

migration "Create messages table" do
  database.create_table :messages do
    text        :message
  end
end

migration "Create players table" do
  database.create_table :players do
    text        :name
    text        :fn
    integer     :score

    index :fn, :unique => true
  end
end

LOGIN_URI = URI('http://susi.apphb.com/api/login').freeze
STUDENT_INFO_URI = URI('http://susi.apphb.com/api/student').freeze

get '/' do
  halt erb(:login) unless @request.cookies.has_key?('key')
  erb :main, locals: { user: @request.cookies['username'].gsub(/\W/, ''),
          players: settings.database[:players].select(:name, :score).map([:name, :score]) }
end

post '/read' do
  settings.database[:messages].select(:message).map(:message).join('\n')
end

post '/write' do
  message = JSON.parse(@request.body.read)['msg']
  settings.database[:messages].insert(:message => message)
  message
end

post '/logout' do
  if(@request.cookies.has_key?('key'))
    data = { 'key' => @request.cookies['key'] }
    send_delete(LOGIN_URI, data)
    @response.delete_cookie('key')
    @response.delete_cookie('username')
  end

  redirect to('/')
end

post '/login' do
  login_data = { 'username' => params[:user], 'password' => params[:password] }
  response_key = send_post(LOGIN_URI, login_data)
  key_data = { 'key' => response_key.body }
  response_user_info = JSON.parse(send_post(STUDENT_INFO_URI, key_data).body)
  fn = response_user_info['facultyNumber']

  settings.database[:players].insert(:name => params[:user], :fn => fn, :score => 0)
  @response.set_cookie('username', params[:user])
  @response.set_cookie('key', response_key.body)

  redirect to('/')
end

def send_delete(uri, data)
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Delete.new(uri.path, {'Content-Type' =>'application/json'})
  request.body = data.to_json
  response = http.request(request)
  response
end

def send_post(uri, data)
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json'})
  request.body = data.to_json
  response = http.request(request)
  response
end
