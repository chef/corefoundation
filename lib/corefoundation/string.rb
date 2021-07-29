module CF
  typedef :pointer, :cfstringref

  attach_function "CFStringCreateWithBytes", %i{pointer buffer_in cfindex uint char}, :cfstringref
  attach_function "CFStringGetBytes", %i{cfstringref uint}, :pointer
  attach_function "CFStringGetMaximumSizeForEncoding", %i{cfindex uint}, :cfindex
  attach_function "CFStringGetLength", [:cfstringref], :cfindex

  attach_function "CFStringGetBytes",
                  [:cfstringref, CF::Range.by_value, :uint, :uchar, :char, :buffer_out, :cfindex, :buffer_out], :cfindex

  attach_function "CFStringCompare", %i{cfstringref cfstringref cfoptionflags}, :cfcomparisonresult

  # Wrapper class for CFString
  # Unlike ruby, CFString is not an arbitrary bag of bytes - the data will be converted to a collection of unicode
  #   characters
  class String < Base
    include Comparable
    register_type("CFString")

    # The cfstring encoding for UTF8
    UTF8 = 0x08000100 # From cfstring.h

    # Creates a string from a ruby string
    # The string must be convertable to UTF-8
    #
    # @param [String] s
    # @return [CF::String]
    def self.from_string(s)
      s_utf = s.encode("UTF-8")
      raw = CF.CFStringCreateWithBytes(nil, s_utf, s_utf.bytesize, UTF8, 0)
      raw.null? ? nil : new(raw)
    end

    # Returns the length, in unicode characters of the string
    # @return [Integer]
    def length
      CF.CFStringGetLength(self)
    end

    # Compares the receiver with the argument
    # @param [CF::String] other
    # @return [Integer]
    def <=>(other)
      Base.check_cftype(other)
      CF.CFStringCompare(self, other, 0)
    end

    # Converts the CF::String to a UTF-8 ruby string
    #
    # @return [String]
    def to_s
      max_size = CF.CFStringGetMaximumSizeForEncoding(length, UTF8)
      range = CF::Range.new
      range[:location] = 0
      range[:length] = length
      buffer = FFI::MemoryPointer.new(:char, max_size)
      cfindex = CF.find_type(:cfindex)
      bytes_used_buffer = FFI::MemoryPointer.new(cfindex)

      CF.CFStringGetBytes(self, range, UTF8, 0, 0, buffer, max_size, bytes_used_buffer)
      len = bytes_used_buffer.send(cfindex == CF.find_type(:long_long) ? :read_long_long : :read_long)

      buffer.read_string(len).force_encoding(Encoding::UTF_8)
    end
    alias to_ruby to_s
  end
end
