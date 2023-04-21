require "ffi" unless defined?(FFI)

module CF
  extend FFI::Library
  ffi_lib [ '/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation', 'libCoreFoundation.so' ]

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
end

require_relative 'corefoundation/refinements'
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
require_relative 'corefoundation/exceptions'
require_relative 'corefoundation/preferences'
require_relative 'corefoundation/url'
