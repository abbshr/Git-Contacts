# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitdb/version'

Gem::Specification.new do |spec|
  spec.name          = "gitdb"
  spec.version       = Gitdb::VERSION
  spec.authors       = ["Ran"]
  spec.email         = ["abbshr@outlook.com"]
  spec.summary       = %q{"Git-Contacts backend data engine"}
  spec.description   = %q{"a simple data storage based on git, designed for Git-Contacts"}
  spec.homepage      = "https://github.com/AustinChou/Git-Contacts"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rugged", "~> 0.21.3"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
