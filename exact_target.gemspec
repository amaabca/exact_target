# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'exact_target/version'

Gem::Specification.new do |spec|
  spec.name          = "exact_target"
  spec.version       = ExactTarget::VERSION
  spec.authors       = ["Michael van den Beuken", "Ruben Estevez", "Jordan Babe", "Mathieu Gilbert", "Ryan Jones", "Darko Dosenovic"]
  spec.email         = ["michael.beuken@gmail.com", "ruben.a.estevez@gmail.com", "jorbabe@gmail.com", "mathieu.gilbert@ama.ab.ca", "ryan.michael.jones@gmail.com", "darko.dosenovic@ama.ab.ca"]
  spec.summary       = %q{manages exact target subscriptions}
  spec.description   = %q{manages exact target subscriptions}
  spec.homepage      = "https://github.com/amaabca/exact_target"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-instafail"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "nokogiri"
  spec.add_development_dependency "factory_girl"
  spec.add_development_dependency 'webmock', "~> 1.22.3"
  spec.add_dependency "rest-client"
  spec.add_dependency "activesupport"
  spec.add_dependency 'activerecord'
  spec.add_dependency "builder"
  spec.add_dependency 'crack'
  spec.add_dependency 'hashie'
end
