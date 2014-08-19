# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "SusiWars"
  spec.version       = "0.1"
  spec.authors       = ["Veselin Genadiev"]
  spec.email         = ["genadiev.veselin@gmail.com"]
  spec.summary       = %q{A quiz game, written with Sinatra and ment to be used by Sofia University members only.}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "data_mapper"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "slim"
  spec.add_development_dependency "thin"
  spec.add_development_dependency "sinatra"
  spec.add_development_dependency "sinatra-contrib"
end
