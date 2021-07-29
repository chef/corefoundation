require "ffi" unless defined?(FFI)

require_relative 'corefoundation/memory'
require_relative 'corefoundation/register'
require_relative 'corefoundation/base'
require_relative 'corefoundation/null'
require_relative 'corefoundation/string'
require_relative 'corefoundation/array'
require_relative 'corefoundation/boolean'
require_relative 'corefoundation/data'
require_relative 'corefoundation/dictionary'
require_relative 'corefoundation/number'
require_relative 'corefoundation/date'

require_relative 'corefoundation/extensions'
require_relative 'corefoundation/preferences'

# REVIEW: Include patches from module
Integer.include CF::CoreExtensions::Integer
Float.include CF::CoreExtensions::Float
Array.include CF::CoreExtensions::Array
TrueClass.include CF::CoreExtensions::TrueClass
FalseClass.include CF::CoreExtensions::FalseClass
String.include CF::CoreExtensions::String
Time.include CF::CoreExtensions::Time
Hash.include CF::CoreExtensions::Hash

