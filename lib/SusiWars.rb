require 'SusiWars/version'
require 'rubygems'
require 'bundler/setup'
require 'thin'
require 'sinatra'

get '/' do
  'Hello world!'
end
