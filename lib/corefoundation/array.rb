module CF
  typedef :pointer, :cfarrayref

  # @private
  class ArrayCallbacks < FFI::Struct
    layout :version, :cfindex, #cfindex
           :retain, :pointer,
           :release, :pointer,
           :copyDescription, :pointer,
           :equal, :pointer
  end

  attach_variable :kCFTypeArrayCallBacks,  ArrayCallbacks
  attach_function :CFArrayCreate, [:pointer, :pointer, :cfindex, :pointer], :cfarrayref
  attach_function :CFArrayCreateMutable, [:pointer, :cfindex, :pointer], :cfarrayref
  attach_function :CFArrayGetValueAtIndex, [:pointer, :cfindex], :pointer
  attach_function :CFArraySetValueAtIndex, [:pointer, :cfindex, :pointer], :void
  attach_function :CFArrayAppendValue, [:pointer, :pointer], :void
  attach_function :CFArrayGetCount, [:pointer], :cfindex
  
  callback :each_applier, [:pointer, :pointer], :void

  attach_function :CFArrayApplyFunction, [:cfarrayref, CF::Range.by_value, :each_applier, :pointer], :void


  # Wrapper class for CFArrayRef. It implements enumberable so you can use a lot of your favourite ruby methods on it.
  #
  # Values returned by the accessor methods or yielded by the block are retained and marked as releasable on garbage collection
  # This means you can safely use the returned values even if the CFArray itself has been destroyed
  #
  # Unlike ruby arrays you cannot set arbitary array indexes - You can only set indexes in the range 0..length
  class Array < Base
    include Enumerable
    register_type("CFArray")
   
    # Whether the array is mutable
    #
    # WARNING: this only works for arrays created by CF::Array, there is no public api for telling whether an arbitrary
    # CFTypeRef is a mutable array or not
    def mutable?
      @mutable
    end

    # Iterates over the array yielding the value to the block
    # The value is wrapped in the appropriate CF::Base subclass and retained (but marked for releasing upon garbage collection)
    # @return self
    def each
      range = CF::Range.new
      range[:location] = 0
      range[:length] = length
      callback = lambda do |value, _|
        yield Base.typecast(value).retain
      end
      CF.CFArrayApplyFunction(self, range, callback, nil)
      self
    end

    # Creates a new, immutable CFArray from a ruby array of cf objects
    # @param [Array<CF::Base>] array The objects to place in the array. They must inherit from CF::Base
    # @return [CF::Array] A CF::Array containing the objects, setup to release the array upon garbage collection
    def self.immutable(array)
      if bad_element = array.detect {|value| !value.is_a?(CF::Base)}
        raise TypeError, "Array contains non cftype #{bad_element.inspect}" 
      end
      m = FFI::MemoryPointer.new(:pointer, array.length)
      m.write_array_of_pointer(array)
      new(CF.CFArrayCreate(nil,m,array.length,CF::kCFTypeArrayCallBacks.to_ptr))
    end

    # Creates a new, empty mutable CFArray
    # @return [CF::Array] A mutable CF::Array containing the objects, setup to release the array upon garbage collection
    def self.mutable
      result = new(CF.CFArrayCreateMutable nil, 0, CF::kCFTypeArrayCallBacks.to_ptr)
      result.instance_variable_set(:@mutable, true)
      result
    end

    # Returns the object at the index
    # @param [Integer] index the 0 based index of the item to retrieve. Behaviour is undefined if it is not in the range 0...size
    # @return [CF::Base] a subclass of CF::Base
    def [](index)
      Base.typecast(CF.CFArrayGetValueAtIndex(self, index)).retain
    end

    # Sets object at the index
    # @param [Integer] index the 0 based index of the item to retrieve. Behaviour is undefined if it is not in the range 0..size
    #   It is legal to set the value at index n of a n item array - this is equivalent to appending the object
    #
    # @param [CF::Base] value the value to store
    # @return [CF::Base] the store value
    def []=(index, value)
      raise TypeError, "instance is not mutable" unless mutable?
      self.class.check_cftype(value)
      CF.CFArraySetValueAtIndex(self, index, value)
    end

    # Appends a value to the array
    #
    # @return [CF::Array] self
    def <<(value)
      raise TypeError, "instance is not mutable" unless mutable?
      self.class.check_cftype(value)
      CF.CFArrayAppendValue(self, value)
      self
    end

    # Returns a ruby array containing the result of calling to_ruby on each of the array's elements
    #
    def to_ruby
      collect(&:to_ruby)
    end

    alias_method :push, :<<

    # Returns the number of elements the array contains
    # @return [Integer]
    def length
      CF.CFArrayGetCount(self)
    end
    alias_method :size, :length
  end
end