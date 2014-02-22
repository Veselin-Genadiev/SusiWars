require 'rake/testtask'

require 'bundler/gem_tasks'

Rake::TestTask.new do |t|
  t.libs = ["lib"]
  t.warning = true
  t.verbose = true
  t.test_files = FileList['spec/*_spec.rb']
end