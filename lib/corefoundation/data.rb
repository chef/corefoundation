module CF
  typedef :pointer, :cfdataref

  attach_function 'CFDataCreate', [:pointer, :buffer_in, :cfindex], :cfdataref  
  attach_function 'CFDataGetLength', [:cfdataref], :cfindex  
  attach_function 'CFDataGetBytePtr', [:cfdataref], :pointer

  # Wrapper for CFData
  #
  #
  class Data < Base
    register_type("CFData")

    # Creates a CFData from a ruby string
    # @param [String] s the string to use
    # @return [CF::Data]
    def self.from_string(s)
      new(CF.CFDataCreate(nil, s, s.bytesize))
    end

    # Creates a ruby string from the wrapped data. The encoding will always be ASCII_8BIT
    #
    # @return [String]
    def to_s
      ptr = CF.CFDataGetBytePtr(self)
      if CF::String::HAS_ENCODING
        ptr.read_string(CF.CFDataGetLength(self)).force_encoding(Encoding::ASCII_8BIT)
      else
        ptr.read_string(CF.CFDataGetLength(self))
      end
    end

    # The size in bytes of the CFData
    # @return [Integer]
    def size
      CF.CFDataGetLength(self)
    end

    alias_method :to_ruby, :to_s
  end
end

