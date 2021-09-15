# frozen_string_literal: true

# The top level namespace for the corefoundation library. The raw FFI generated methods are attached here
module CF
  attach_function :show, 'CFShow', [:cftyperef], :void
  attach_function :release, 'CFRelease', [:cftyperef], :void
  attach_function :retain, 'CFRetain', [:cftyperef], :cftyperef
  attach_function 'CFEqual', [:cftyperef, :cftyperef], :char
  attach_function 'CFHash', [:cftyperef], :cfhashcode
  attach_function 'CFCopyDescription', [:cftyperef], :cftyperef
  attach_function 'CFGetTypeID', [:cftyperef], :cftypeid

  # Provides a more declarative way to define all required abstract methods.
  # This gets included in the CF::Base class whose subclasses then need to define those methods.
  module Memory

    # Returns a ruby string containing the output of CFCopyDescription for the wrapped object
    #
    # @return [String]
    def inspect
      CF::String.new(CF.CFCopyDescription(self)).to_s
    end

    # Calls CFRelease on the wrapped pointer
    #
    # @return Returns self
    def release
      CF.release(self)
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
  end
end
