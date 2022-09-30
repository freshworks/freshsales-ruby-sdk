# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'freshsales/analytics/version'

Gem::Specification.new do |spec|
  spec.name          = "freshsales-analytics"
  spec.version       = Freshsales::Analytics::VERSION
  spec.authors      = ["Freshsales Team"]
  spec.email         = ["support@freshsales.io"]
  spec.summary       = %q{Freshsales tracking Library for Ruby.}
  spec.description   = %q{Freshsales tracking Library for Ruby.}
  spec.homepage      = "https://www.freshsales.io/libraries/ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.2.10"
  spec.add_development_dependency "rake"
  spec.add_dependency "httparty"
  spec.add_dependency "json"
end
