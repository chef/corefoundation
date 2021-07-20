# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'corefoundation/version'

Gem::Specification.new do |s|
  s.name = 'corefoundation'
  s.version = CF::VERSION

  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.authors = ['Amulya Tomer']
  s.description = 'FFI based Ruby wrappers for Core Foundation '
  s.email = 'atomer@progress.com'
  s.files += Dir['lib/**/*.rb']
  s.files += Dir['spec/**/*']
  s.files += ['README.md', 'LICENSE', 'CHANGELOG']
  s.license = 'MIT'
  s.homepage = 'https://github.com/chef/corefoundation'
  s.require_paths = ['lib']
  s.rubygems_version = '1.8.10'
  s.summary = 'Ruby wrapper for OS X corefoundation'
  s.required_ruby_version = '>= 1.8.7'

  s.add_runtime_dependency 'ffi'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'yard'
end
