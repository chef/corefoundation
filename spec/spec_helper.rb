require 'rubygems'
require 'bundler/setup'
require 'simplecov'
require 'simplecov-console'

SimpleCov.start do
  add_filter '/spec/'
  track_files '{lib}/**/*.rb'
  enable_coverage :branch
  refuse_coverage_drop :line, :branch
  minimum_coverage line: 95, branch: 90
  formatter SimpleCov::Formatter::Console
end

$: << File.dirname(__FILE__) + '/../lib'

require 'corefoundation'

RSpec.configure do |config|
  
end