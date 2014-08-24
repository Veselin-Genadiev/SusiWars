require 'rubygems'
require 'sinatra/base'
require 'sinatra/contrib'
require 'haml'
require 'json'
require 'net/http'
require 'data_mapper'
require './lib/user_factory'
require './lib/game_factory'

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
      if @user_info
        cookies[:room] = 'none'
        haml :index
      else
        haml :login
      end
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
      @response.set_cookie('username', params[:login])
      UserFactory.user(cookies[:username])
      redirect '/'
    end

    get '/logout' do
      logout_data = { key: cookies[:key] }
      send_delete(LOGIN_URI, logout_data)
      cookies.clear
      redirect '/'
    end

    get '/admin' do
      @user = UserFactory.user(cookies[:username])
      p @user
      if @user.permission != 'bash_admin'
        redirect '/'
      end

      @users = UserFactory.users
      p @users
      haml :admin
    end

    post '/admin' do
      @user = UserFactory.user(cookies[:username])
      if @user.permission != 'bash_admin'
        redirect '/'
      end

      p params[:username]
      UserFactory.admin(params[:username])
      redirect '/'
    end

    get '/question' do
      @user = UserFactory.user(cookies[:username])
      if @user.permission != 'admin' and @user.permission != 'bash_admin'
        redirect '/'
      end

      haml :question
    end

    post '/question' do
      @user = UserFactory.user(cookies[:username])
      if @user.permission != 'admin' and @user.permission != 'bash_admin'
        redirect '/'
      end

      Question.first_or_create({ question: params[:question],
                                 first_answer: params[:first_answer],
                                 second_answer: params[:second_answer],
                                 third_answer: params[:third_answer],
                                 fourth_answer: params[:fourth_answer],
                                 correct_answer: params[:correct_answer] })

        redirect '/'
    end
  end
end
