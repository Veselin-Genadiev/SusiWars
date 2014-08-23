require 'sinatra/base'
require 'sinatra/contrib'
require 'haml'
require 'json'
require 'net/http'
require 'data_mapper'

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

module SusiWars
  class App < Sinatra::Base
    helpers Sinatra::Cookies

    get '/' do
      @user_info = JSON.parse(cookies[:user_info]) if cookies[:user_info]
      @login_key = cookies[:key]
      cookies[:room] = 'none'
      haml :index
    end

    post '/login' do
      login_data = { username: params[:login], password: params[:password] }
      login_response = send_post(LOGIN_URI, login_data)

      if login_response.code[0] != '2'
        redirect '/'
      end

      authentication_data = { key: login_response.body }
      authentication_response = send_post(STUDENT_INFO_URI, authentication_data).body
      @response.set_cookie('user_info', authentication_response)
      @response.set_cookie('key', login_response.body)
      redirect '/'
    end
  end
end
