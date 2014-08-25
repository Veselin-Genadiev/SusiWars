require 'data_mapper'
require 'dm-sqlite-adapter'
require 'sinatra' unless defined?(Sinatra)

Dir["lib/*.rb"].each { |file| require_relative 'lib/' + File.basename(file, '.rb') }

DataMapper.setup(:default, (ENV["DATABASE_URL"] || "sqlite://#{Dir.pwd}/SusiWars.db"))
DataMapper.finalize
DataMapper.auto_migrate!
