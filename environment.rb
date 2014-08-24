require 'data_mapper'
require 'dm-sqlite-adapter'
require 'sinatra' unless defined?(Sinatra)

Dir["lib/*.rb"].each do |file|
  if not File.basename(file, '.rb').end_with?('factory')
    require './lib/' + File.basename(file, '.rb')
  end
end

DataMapper.setup(:default, (ENV["DATABASE_URL"] || "sqlite://#{Dir.pwd}/SusiWars.db"))
DataMapper.finalize
#DataMapper.auto_migrate!
