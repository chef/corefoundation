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
  attach_function 'CFEqual', %i[cftyperef cftyperef], :char
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
  module BaseWrapper
    @registered_types = {}

    def self.included(base)
      base.extend RegisteredTypes
      base.class_eval do
        def self.abstract_methods(*methods)
          methods.each do |name|
            define_method name do
              raise NotImplementedError, "No implementation found for #{name} in #{self.class.name} class."
            end
          end
        end
      end
    end

    # Class methods
    module RegisteredTypes
      # Adds the type to @registered_types
      def register_type(type_name)
        CF.attach_function "#{type_name}GetTypeID", [], :cftypeid
        types = BaseWrapper.instance_variable_get(:@registered_types)
        types[CF.send("#{type_name}GetTypeID")] = self
        BaseWrapper.instance_variable_set(:@registered_types, types)
      end

      private

      def klass_from_cf_type(cftyperef)
        klass = BaseWrapper.instance_variable_get(:@registered_types)[CF.CFGetTypeID(cftyperef)]
        raise TypeError, "No class registered for cf type #{cftyperef.inspect}" unless klass

        klass
      end
    end

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
