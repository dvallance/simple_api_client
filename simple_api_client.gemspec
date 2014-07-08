# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_api_client/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_api_client"
  spec.version       = SimpleApiClient::VERSION
  spec.authors       = ["Dave Vallance"]
  spec.email         = ["davevallance@gmail.com"]
  spec.summary       = %q{A module to help create api clients quickly.}
  spec.description   = %q{A module to help create api clients quickly. The idea is you should only have to define your endpoints and not worry about setup and the http client.}
  spec.homepage      = "https://github.com/dvallance/simple_api_client"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'activesupport'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "nokogiri"
  spec.add_development_dependency "guard-minitest"
  spec.add_development_dependency "shotgun"
  spec.add_development_dependency "sinatra"
end
