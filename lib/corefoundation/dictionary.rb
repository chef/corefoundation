module CF
  # @private
  class DictionaryKeyCallbacks < FFI::Struct
    layout :version, :cfindex,
           :retain, :pointer,
           :release, :pointer,
           :copyDescription, :pointer,
           :equal, :pointer,
           :hash, :pointer
  end
  # @private
  class DictionaryValueCallbacks < FFI::Struct
    layout :version, :cfindex,
           :retain, :pointer,
           :release, :pointer,
           :copyDescription, :pointer,
           :equal, :pointer
  end

  typedef :pointer, :cfdictionaryref
  attach_variable :kCFTypeDictionaryKeyCallBacks,  DictionaryKeyCallbacks
  attach_variable :kCFTypeDictionaryValueCallBacks,  DictionaryValueCallbacks
  attach_function :CFDictionaryCreateMutable, [:pointer, :cfindex, :pointer, :pointer], :cfdictionaryref

  attach_function :CFDictionarySetValue, [:cfdictionaryref, :pointer, :pointer], :void
  attach_function :CFDictionaryGetValue, [:cfdictionaryref, :pointer], :pointer

  attach_function :CFDictionaryGetValue, [:cfdictionaryref, :pointer], :pointer
  attach_function :CFDictionaryGetCount, [:cfdictionaryref], :cfindex

  callback :each_applier, [:pointer, :pointer, :pointer], :void

  attach_function :CFDictionaryApplyFunction, [:cfdictionaryref, :each_applier, :pointer], :void

  # Wrapper class for CFDictionary. It implements Enumerable.
  #
  # Values returned by the accessor methods or yielded by the block are retained and marked as releasable on garbage collection
  # This means you can safely use the returned values even if the CFDictionary itself has been destroyed
  #
  class Dictionary < Base
    register_type("CFDictionary")
    include Enumerable

    # Return a new, empty mutable CF::Dictionary
    #
    #
    # @return [CF::Dictionary]
    def self.mutable
      new(CF.CFDictionaryCreateMutable nil, 0, CF.kCFTypeDictionaryKeyCallBacks.to_ptr, CF.kCFTypeDictionaryValueCallBacks.to_ptr)
    end

    # Iterates over the array yielding the value to the block
    # The value is wrapped in the appropriate CF::Base subclass and retained (but marked for releasing upon garbage collection)
    # @return self

    def each
      callback = lambda do |key, value, _|
        yield [Base.typecast(key), Base.typecast(value)]
      end
      CF.CFDictionaryApplyFunction(self, callback, nil)
      self
    end

    # Returns the value associated with the key, or nil
    # The key should be a CF::Base instance. As a convenience, instances of string will be converted to CF::String
    # @param [CF::Base, String] key the key to access
    # @return [CF::Base, nil]

    def [](key)
      key = CF::String.from_string(key) if key.is_a?(::String)
      self.class.check_cftype(key)
      raw = CF.CFDictionaryGetValue(self, key)
      raw.null? ? nil : self.class.typecast(raw)
    end

    # Sets the value associated with the key, or nil
    # The key should be a CF::Base instance. As a convenience, instances of string will be converted to CF::String
    # @param [CF::Base, String] key the key to access
    # @param [CF::Base] value the value to set
    # @return [CF::Base] the value that was set
    def []=(key, value)
      key = CF::String.from_string(key) if key.is_a?(::String)
      self.class.check_cftype(key)
      self.class.check_cftype(value)
      CF.CFDictionarySetValue(self, key, value)
    end

    # Adds the key value pairs from the argument to self
    #
    # @param [CF::Dictionary] other
    # @return self
    def merge!(other)
      other.each do |k,v|
        self[k] = v
      end
      self
    end

    # Returns the number of key value pairs in the dictionary
    # @return [Integer]
    def length
      CF.CFDictionaryGetCount(self)
    end

    # Returns a ruby hash constructed by calling `to_ruby` on each key and value
    #
    # @return [Hash]
    def to_ruby
      Hash[collect {|k,v| [k.to_ruby, v.to_ruby]}]
    end
    alias_method :size, :length
  end
end