# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruboty/pux/version'

Gem::Specification.new do |spec|
  spec.name          = "ruboty-pux"
  spec.version       = Ruboty::Pux::VERSION
  spec.authors       = ["yamasy1549"]
  spec.email         = ["sanae@yamasy.info"]
  spec.summary       = "Detect and judge the face of a photo."
  spec.homepage      = "https://github.com/yamasy1549/ruboty-pux"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "mechanize", ">=2.7.3"
  spec.add_dependency "ruboty", ">= 1.1.0"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
