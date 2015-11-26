require "simplecov"
require "rspec"
require "exact_target"
require "coveralls"
require "ostruct"
require "nokogiri"
require "factory_girl"
require 'webmock'
require ::File.expand_path("fixtures/params.rb", File.dirname(__FILE__))
Coveralls.wear!

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
