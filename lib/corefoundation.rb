# frozen_string_literal: true

require 'ffi'
require 'iconv' if RUBY_VERSION < '1.9'

require 'corefoundation/memory'
require 'corefoundation/register'
require 'corefoundation/base'
require 'corefoundation/null'
require 'corefoundation/string'
require 'corefoundation/array'
require 'corefoundation/boolean'
require 'corefoundation/data'
require 'corefoundation/dictionary'
require 'corefoundation/number'
require 'corefoundation/date'

require 'corefoundation/error'
require 'corefoundation/extensions'
require 'corefoundation/preferences'

# REVIEW: Include patches from module
Integer.include CF::CoreExtensions::Integer
Float.include CF::CoreExtensions::Float
Array.include CF::CoreExtensions::Array
TrueClass.include CF::CoreExtensions::TrueClass
FalseClass.include CF::CoreExtensions::FalseClass
String.include CF::CoreExtensions::String
Time.include CF::CoreExtensions::Time
Hash.include CF::CoreExtensions::Hash
