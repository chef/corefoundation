require 'ffi'
require 'iconv' if RUBY_VERSION < "1.9"

# CF Types
require 'corefoundation/base'
require 'corefoundation/null'
require 'corefoundation/string'
require 'corefoundation/array'
require 'corefoundation/boolean'
require 'corefoundation/data'
require 'corefoundation/dictionary'
require 'corefoundation/number'
require 'corefoundation/date'
require 'corefoundation/extensions'

# Error wrapper
require 'corefoundation/error'

# Utilities
require 'corefoundation/preferences'
