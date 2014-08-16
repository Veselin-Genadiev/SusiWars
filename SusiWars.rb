require 'sinatra'
require 'sinatra/contrib'
require 'haml'
require 'json'
require 'net/http'

LOGIN_URI = URI('http://susi.apphb.com/api/login').freeze
STUDENT_INFO_URI = URI('http://susi.apphb.com/api/student').freeze

def send_delete(uri, data)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Delete.new(uri.path, 'Content-Type' => 'application/json')
    request.body = data.to_json
    response = http.request(request)
    response
end

def send_post(uri, data)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    request.body = data.to_json
    response = http.request(request)
    response
end

get '/' do
  #user_info should point to the entry in the database.
  @user_info = cookies[:faculty_number]
  @login_key = cookies[:key]
  #check if login_key has expired.
  haml :index
end

post '/login' do
  login_data = { username: params[:login], password: params[:password] }
  login_response = send_post(LOGIN_URI, login_data)

  if login_response.code[0] != '2'
    redirect '/'
  end

  authentication_data = { key: login_response.body }
  authentication_response = JSON.parse(send_post(STUDENT_INFO_URI,
                                                 authentication_data).body)
  faculty_number = authentication_response['facultyNumber']

  @response.set_cookie('faculty_number', faculty_number)
  @response.set_cookie('key', login_response.body)
  redirect '/'
end
