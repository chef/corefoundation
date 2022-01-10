# frozen_string_literal: true

# The top level namespace for the corefoundation library. The raw FFI generated methods are attached here
module CF
  # The base class for all of the wrapper classes in CF module.
  class Base
    using CF::Refinements

    @@type_map = {}
    include CF::Register
    include CF::Memory

    attr_reader :ptr

    # Raises an exception if the argument does not inherit from CF::Base
    #
    # @param cftyperef object to check
    def self.check_cftype(cftyperef)
      raise TypeError, "#{cftyperef.inspect} is not a cftype" unless cftyperef.is_a?(CF::Base)
    end

    # Wraps an FFI::Pointer with the appropriate subclass of CF::Base
    # If the pointer is not a CFTypeRef behaviour is undefined
    #
    # @param [FFI::Pointer] cftyperef Object to wrap
    # @return A wrapper object inheriting from CF::Base
    def self.typecast(cftyperef)
      klass = klass_from_cf_type cftyperef
      klass.new(cftyperef)
    end

    # @param [FFI::Pointer] pointer The pointer to wrap
    def initialize(pointer)
      @ptr = FFI::Pointer.new(pointer)
      ObjectSpace.define_finalizer(self, self.class.finalize(ptr))
    end

    # @param [FFI::Pointer] pointer to the address of the object
    def self.finalize(pointer)
      proc { CF.release(pointer) unless pointer.address.zero? }
    end

    # Whether the instance is the CFNull singleton
    #
    # @return [Boolean]
    def null?
      equals?(CF::NULL)
    end

    # Uses CFHash to  return a hash code
    #
    # @return [Integer]
    def hash
      CF.CFHash(self)
    end

    # eql? (and ==) are implemented using CFEqual
    def eql?(other)
      if other.is_a?(CF::Base)
        CF.CFEqual(self, other) != 0
      else
        false
      end
    end

    alias == :eql?

    # equals? is defined as returning true if the wrapped pointer is the same
    def equals?(other)
      if other.is_a?(CF::Base)
        @ptr.address == other.to_ptr.address
      else
        false
      end
    end

    def to_ruby
      raise CF::Exceptions::MethodNotImplemented, "#{self.class} should implement the to_ruby method."
    end

    # This is a no-op on CF::Base and its subclasses. Always returns self.
    #
    # @return Returns self
    def to_cf
      self
    end

    private
    def self.type_map
      @@type_map
    end
  end
end
