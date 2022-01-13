lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'corefoundation/version'

Gem::Specification.new do |s|
  s.name = %q{corefoundation}
  s.version = CF::VERSION

  s.authors = ["Frederick Cheung", "Chef Software, Inc."]
  s.description = %q{Ruby wrapper for macOS Core Foundation framework}
  s.summary = %q{Ruby wrapper for macOS Core Foundation framework}
  s.email = ["frederick.cheung@gmail.com", "oss@chef.io"]
  s.files += Dir["lib/**/*.rb"]
  s.files += ["LICENSE"]
  s.license = "MIT"
  s.homepage = "http://github.com/chef/corefoundation"
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 2.6'

  s.add_runtime_dependency "ffi", "1.15.4"
  s.add_development_dependency "rspec", ">= 3.0"
  s.add_development_dependency "rake"
  s.add_development_dependency "chefstyle", "2.2.0"
  s.add_development_dependency "yard"
end
