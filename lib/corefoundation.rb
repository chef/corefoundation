require "ffi" unless defined?(FFI)

module CF
  extend FFI::Library
  ffi_lib '/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation'
  ffi_lib '/System/Library/Frameworks/Security.framework/Security'
  

  if FFI::Platform::ARCH == 'x86_64'
    typedef :long_long, :cfindex
    typedef :long_long, :cfcomparisonresult
    typedef :ulong_long, :cfoptionflags
    typedef :ulong_long, :cftypeid
    typedef :ulong_long, :cfhashcode
  else
    typedef :long, :cfindex
    typedef :long, :cfcomparisonresult
    typedef :ulong, :cfoptionflags
    typedef :ulong, :cftypeid
    typedef :ulong, :cfhashcode
  end

  typedef :pointer, :cftyperef
  typedef :pointer, :cfdataref
end

require_relative 'corefoundation/memory'
require_relative 'corefoundation/register'
require_relative 'corefoundation/base'
require_relative 'corefoundation/null'
require_relative 'corefoundation/range'
require_relative 'corefoundation/string'
require_relative 'corefoundation/array'
require_relative 'corefoundation/boolean'
require_relative 'corefoundation/data'
require_relative 'corefoundation/dictionary'
require_relative 'corefoundation/number'
require_relative 'corefoundation/date'
require_relative 'corefoundation/preferences'
require_relative 'corefoundation/extensions'
require_relative 'corefoundation/security'

# REVIEW: Include patches from module
Integer.include CF::CoreExtensions::Integer
Float.include CF::CoreExtensions::Float
Array.include CF::CoreExtensions::Array
TrueClass.include CF::CoreExtensions::TrueClass
FalseClass.include CF::CoreExtensions::FalseClass
String.include CF::CoreExtensions::String
Time.include CF::CoreExtensions::Time
Hash.include CF::CoreExtensions::Hash
