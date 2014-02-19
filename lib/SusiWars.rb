require 'SusiWars/version'
require 'rubygems'
require 'bundler/setup'
require 'thin'
require 'json'
require 'sinatra'
require 'net/http'
require 'uri'

get '/' do
  'Hello world!'
end

post '/login/:data' do
  content_type :json

  POST /api/login HTTP/1.1
  Host: susi.apphb.com
  Content-Type: application/json
  Content-Length: 46
  { username: "vgenadiev", password: "password" }
end
