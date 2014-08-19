require 'bundler/setup'
require 'rspec/core/rake_task'
require 'data_mapper'

task :default => :test
task :test => :spec

if !defined?(RSpec)
  puts "spec targets require RSpec"
else
  desc "Run all examples"
  RSpec::Core::RakeTask.new(:spec) do |t|
    #t.pattern = 'spec/**/*_spec.rb' # not needed this is default
    t.rspec_opts = ['-cfs']
  end
end

namespace :db do
  desc 'Auto-migrate the database (destroys data)'
  task :migrate => :environment do
    DataMapper.finalize
    DataMapper.auto_migrate!
  end

  desc 'Auto-upgrade the database (preserves data)'
  task :upgrade => :environment do
    DataMapper.finalize
    DataMapper.auto_upgrade!
  end

  desc 'Specify sqlite connection'
  task :sqlite3 do
    DataMapper.setup(:default, "sqlite://#{Dir.pwd}/development.db")
  end

  desc 'Specify postgres connection'
  task :postgres do
    DataMapper.setup(:default, 'postgres://user:password@hostname/databasea')
  end
end

task :environment do
  Dir["lib/*.rb"].each {|file| require file }
end
