require 'rubygems'
require 'sinatra/base'
require 'sinatra/contrib'
require 'haml'
require 'json'
require 'net/http'
require 'data_mapper'
require_relative 'lib/user'
require_relative 'lib/game'
require_relative 'lib/question'
require_relative 'lib/sinatra/output_verifier'

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
    helpers OutputHelper

    get '/' do
      @user_info = JSON.parse(cookies[:user_info]) if cookies[:user_info]
      if @user_info
        @response.set_cookie('game', 'none')

        if(cookies[:username] == 'vgenadiev')
          User.bash_admin(cookies[:username])
        else
          User.user(cookies[:username])
        end

        haml(:index) + verification_tag(:index)
      else
        haml(:login) + verification_tag(:login)
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

      redirect '/'
    end

    get '/logout' do
      logout_data = { key: cookies[:key] }
      send_delete(LOGIN_URI, logout_data)
      cookies.clear
      redirect '/'
    end

    get '/admin' do
      @user = User.user(cookies[:username])
      if @user.permission != :bash_admin
        redirect '/'
      end

      @users = User.users
      haml(:admin) + verification_tag(:admin)
    end

    post '/admin' do
      @user = User.user(cookies[:username])
      if @user.permission != :bash_admin
        redirect '/'
      end

      User.admin(params[:username])
      redirect '/'
    end

    get '/question' do
      @user = User.user(cookies[:username])
      if @user.permission != :admin and @user.permission != :bash_admin
        redirect '/'
      end

      haml(:question) + verification_tag(:question)
    end

    post '/question' do
      @user = User.user(cookies[:username])
      if @user.permission != :admin and @user.permission != :bash_admin
        redirect '/'
      end

      Question.question(params[:question], params[:first_answer],
                        params[:second_answer], params[:third_answer],
                        params[:fourth_answer], params[:correct_answer])

      redirect '/'
    end

    get '/game_list' do
      @games = Game.open_games.map { |game| {id: game.id, owner: game.users.first.username} }
      #@games = @games.select { |game| game.owner != cookies[:username] }
      @games.to_json
    end

    get '/game' do
      @user_info = JSON.parse(cookies[:user_info]) if cookies[:user_info]
      if(params[:id])
        @game = Game.join_game(params[:id].to_i, cookies[:username])
      else
        @game = Game.create_game(cookies[:username])
      end

      @response.set_cookie('game', @game.id)
      haml(:game) + verification_tag(:game)
    end

    post '/game' do
      Game.update_users_score(params[:id].to_i)
    end

    post '/answer' do
      if Question.correct_answered(params[:question_id].to_i, params[:answer])
        Game.update_result(params[:id].to_i, cookies[:username])
      end
    end
  end
end
