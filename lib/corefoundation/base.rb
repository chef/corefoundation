
# The top level namespace for the corefoundation library. The raw FFI generated methods are attached here
#
#
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


  # @private
  class Range < FFI::Struct
    layout :location, :cfindex,
           :length, :cfindex
  end

  typedef :pointer, :cftyperef

  #general utility functions
  attach_function :show, 'CFShow', [:cftyperef], :void
  attach_function :release, 'CFRelease', [:cftyperef], :void
  attach_function :retain, 'CFRetain', [:cftyperef], :cftyperef
  attach_function 'CFEqual', [:cftyperef, :cftyperef], :char
  attach_function 'CFHash', [:cftyperef], :cfhashcode
  attach_function 'CFCopyDescription', [:cftyperef], :cftyperef
  attach_function 'CFGetTypeID', [:cftyperef], :cftypeid

  # The base class for all of the wrapper classes 
  #
  # @abstract
  class Base  
    @@type_map = {}

    # @private
    class Releaser
      def initialize(ptr)
        @address  = ptr.address
      end

      def call *ignored
        if @address != 0
          CF.release(@address)
          @address = 0
        end
      end
    end

    class << self
      # Raises an exception if the argument does not inherit from CF::Base
      #
      # @param cftyperef object to check
      def check_cftype(cftyperef)
        raise TypeError, "#{cftyperef.inspect} is not a cftype" unless cftyperef.is_a?(CF::Base)
      end

      # Wraps an FFI::Pointer with the appropriate subclass of CF::Base
      # If the pointer is not a CFTypeRef behaviour is undefined
      # @param [FFI::Pointer] cftyperef Object to wrap
      # @return A wrapper object inheriting from CF::Base
      def typecast(cftyperef)
        klass = klass_from_cf_type cftyperef
        klass.new(cftyperef)
      end

      private
      def klass_from_cf_type cftyperef
        klass = @@type_map[CF.CFGetTypeID(cftyperef)]
        if !klass
          raise TypeError, "No class registered for cf type #{cftyperef.inspect}"
        end
        klass
      end

      def register_type(type_name)
        CF.attach_function "#{type_name}GetTypeID", [], :cftypeid
        @@type_map[CF.send("#{type_name}GetTypeID")] = self
      end

    end

    # 
    #
    # @param [FFI::Pointer] ptr The pointer to wrap
    def initialize(ptr)
      @ptr = FFI::Pointer.new(ptr)
    end

    # Returns the wrapped pointer
    # @return [FFI::Pointer]
    def to_ptr
      @ptr
    end

    # Sets the wrapper pointer. You should only do this rarely. If you have used release_on_gc then that
    # finalizer will still be called on the original pointer value
    #
    def ptr= ptr
      @ptr = ptr
    end

    # Calls CFRetain on the wrapped pointer
    # @return Returns self
    def retain
      CF.retain(self)
      self
    end

    # Calls CFRelease on the wrapped pointer
    # @return Returns self
    def release
      CF.release(self)
      self
    end

    # Installs a finalizer on the wrapper object that will cause it to call CFRelease on the pointer
    # when the wrapper is garbage collected
    # @return Returns self
    def release_on_gc
      ObjectSpace.define_finalizer(@ptr, Releaser.new(@ptr))
      self
    end

    # Returns a ruby string containing the output of CFCopyDescription for the wrapped object
    #
    # @return [String]
    def inspect
      cf = CF::String.new(CF.CFCopyDescription(self))
      cf.to_s.tap {cf.release}
    end

    # Uses CFHash to  return a hash code
    #
    # @return [Integer]
    def hash
      CF.CFHash(self)
    end

    # eql? (and ==) are implemented using CFEqual
    #
    #
    def eql?(other)
      if other.is_a?(CF::Base)
        CF.CFEqual(self, other) != 0
      else
        false
      end
    end
    
    # equals? is defined as returning true if the wrapped pointer is the same
    #
    #
    def equals?(other)
      if other.is_a?(CF::Base)
        address == other.address
      else
        false
      end
    end
    
    alias_method :==, :eql?

    # Converts the CF object into a ruby object. Subclasses typically override this to return
    # an appropriate object (for example CF::String returns a String)
    #
    def to_ruby
      self
    end

    # to_cf is a no-op on CF::Base and its descendants - it always returns self
    #
    #
    def to_cf
      self
    end
  end

end
