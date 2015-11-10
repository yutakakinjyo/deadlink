# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'deadlink/version'

Gem::Specification.new do |spec|
  spec.name          = "deadlink"
  spec.version       = Deadlink::VERSION
  spec.authors       = ["yutakakinjyo"]
  spec.email         = ["yutakakinjyo@gmail.com"]

  spec.summary       = %q{check deadlink from markdown file in your git repository}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/yutakakinjyo/deadlink"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "fakefs"
  spec.add_development_dependency "codeclimate-test-reporter", require: nil

end
