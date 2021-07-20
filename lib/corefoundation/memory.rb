# frozen_string_literal: true

# The top level namespace for the corefoundation library. The raw FFI generated methods are attached here
module CF
  extend FFI::Library
  ffi_lib '/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation'

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

  attach_function :show, 'CFShow', [:cftyperef], :void
  attach_function :release, 'CFRelease', [:cftyperef], :void
  attach_function :retain, 'CFRetain', [:cftyperef], :cftyperef
  attach_function 'CFEqual', [:cftyperef, :cftyperef], :char
  attach_function 'CFHash', [:cftyperef], :cfhashcode
  attach_function 'CFCopyDescription', [:cftyperef], :cftyperef
  attach_function 'CFGetTypeID', [:cftyperef], :cftypeid

  # @private
  class Range < FFI::Struct
    layout :location, :cfindex,
           :length, :cfindex
  end

  # Provides a more declarative way to define all required abstract methods.
  # This gets included in the CF::Base class whose subclasses then need to define those methods.
  module Memory

    # Private releaser class providers the block to execute after garbage collection.
    # REVIEW: If we remove setter for `@ptr`, then we can probably remove the need for this class
    #   and directly define a proc in the release_on_gc method.
    class Releaser
      def initialize(ptr)
        @address = ptr.address
      end

      def call(*)
        return unless @address != 0

        CF.release(@address)
        @address = 0
      end
    end

    # Returns a ruby string containing the output of CFCopyDescription for the wrapped object
    #
    # @return [String]
    def inspect
      cf = CF::String.new(CF.CFCopyDescription(self))
      cf.to_s.tap { cf.release }
    end

    # Calls CFRelease on the wrapped pointer
    #
    # @return Returns self
    def release
      CF.release(self)
      self
    end

    # Installs a finalizer on the wrapper object that will cause it to call CFRelease on the pointer
    # when the wrapper is garbage collected
    #
    # @return Returns self
    def release_on_gc
      ObjectSpace.define_finalizer(ptr, Releaser.new(ptr))
      self
    end

    # Calls CFRetain on the wrapped pointer
    #
    # @return Returns self
    def retain
      CF.retain(self)
      self
    end

    # This is a no-op on CF::Base and its subclasses. Always returns self.
    #
    # @return Returns self
    def to_cf
      self
    end

    # Returns the wrapped pointer
    #
    # @return [FFI::Pointer]
    def to_ptr
      ptr
    end

    private_constant :Releaser
  end
end
