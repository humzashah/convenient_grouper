# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'convenient_grouper/version'

Gem::Specification.new do |spec|
  spec.name          = "convenient_grouper"
  spec.version       = ConvenientGrouper::VERSION
  spec.authors       = ["Syed Humza Shah"]
  spec.email         = ["humzashah+github@gmail.com"]

  spec.summary       = "Use Ruby hashes to group database table rows through ActiveRecord."
  spec.homepage      = "https://github.com/humzashah/convenient_grouper"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_development_dependency "bundler", ">= 1.8"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "activerecord", ">= 4.0"
  spec.add_development_dependency "rspec"
end
