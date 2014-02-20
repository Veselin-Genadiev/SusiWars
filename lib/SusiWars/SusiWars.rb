require 'SusiWars/version'
require 'rubygems'
require 'bundler/setup'
require 'thin'
require 'json'
require 'sinatra/base'
require 'net/http'
require 'uri'

class ApplicationServer < Sinatra::Base
  LOGIN_URI = URI('http://susi.apphb.com/api/login')
  STUDENT_INFO_URI = URI('http://susi.apphb.com/api/student')

  get '/' do
    File.read(File.join('public', 'index.html'))
  end

  post '/logout' do
    if(@request.cookies[:login_key])
      data = { 'key' => @request.cookies[:login_key] }
      send_delete(LOGIN_URI, data)
      @response.delete_cookie(:login_key, nil)
      redirect to('/')
    end
  end

  post '/login' do
    login_data = { 'username' => params[:login], 'password' => params[:password] }
    response_key = send_post(LOGIN_URI, login_data)
    key_data = { 'key' => response_key.body }
    response_user_info = send_post(STUDENT_INFO_URI, key_data)
    response_user_info.body
    @response.set_cookie(:login_key, response_key.body)
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

  run!
end
