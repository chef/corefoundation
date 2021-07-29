module CF
  typedef :pointer, :cfnumberref
  enum :cf_number_type, [
    :kCFNumberSInt8Type, 1,
    :kCFNumberSInt16Type, 2,
    :kCFNumberSInt32Type, 3,
    :kCFNumberSInt64Type, 4,
    :kCFNumberFloat32Type, 5,
    :kCFNumberFloat64Type, 6,
    :kCFNumberCharType, 7,
    :kCFNumberShortType, 8,
    :kCFNumberIntType, 9,
    :kCFNumberLongType, 10,
    :kCFNumberLongLongType, 11,
    :kCFNumberFloatType, 12,
    :kCFNumberDoubleType, 13,
    :kCFNumberCFIndexType, 14,
    :kCFNumberNSIntegerType, 15,
    :kCFNumberCGFloatType, 16,
    :kCFNumberMaxType, 16
  ]

  attach_function "CFNumberGetValue", %i{cfnumberref cf_number_type pointer}, :uchar
  attach_function "CFNumberCreate", %i{pointer cf_number_type pointer}, :cfnumberref
  attach_function "CFNumberIsFloatType", [:pointer], :uchar
  attach_function "CFNumberCompare", %i{cfnumberref cfnumberref pointer}, :cfcomparisonresult

  # Wrapper for CFNumberRef
  #
  #
  class Number < Base
    register_type "CFNumber"
    include Comparable

    # Constructs a CF::Number from a float
    # @param [Float] float
    # @return [CF::Number]
    def self.from_f(float)
      p = FFI::MemoryPointer.new(:double)
      p.write_double(float.to_f)
      new(CF.CFNumberCreate(nil, :kCFNumberDoubleType, p))
    end

    # Constructs a CF::Number from an integer
    # @param [Integer] int
    # @return [CF::Number]
    def self.from_i(int)
      p = FFI::MemoryPointer.new(:int64)
      p.put_int64(0, int.to_i)
      new(CF.CFNumberCreate(nil, :kCFNumberSInt64Type, p))
    end

    # Compares the receiver with the argument
    # @param [CF::Number] other
    # @return [Integer]
    def <=>(other)
      raise TypeError, "argument should be CF::Number" unless other.is_a?(CF::Number)

      CF.CFNumberCompare(self, other, nil)
    end

    # Converts the CF::Number to either an Integer or a Float, depending on the result of CFNumberIsFloatType
    #
    # @return [Integer, Float]
    def to_ruby
      if CF.CFNumberIsFloatType(self) == 0
        to_i
      else
        to_f
      end
    end

    # Converts the CF::Number to an integer
    # May raise if the conversion cannot be done without loss of precision
    # @return [Integer]
    def to_i
      p = FFI::MemoryPointer.new(:int64)
      if CF.CFNumberGetValue(self, :kCFNumberSInt64Type, p) == 0
        raise "CF.CFNumberGetValue failed to convert #{inspect} to kCFNumberSInt64Type"
      end

      p.get_int64 0
    end

    # Converts the CF::Number to a float
    # May raise if the conversion cannot be done without loss of precision
    # @return [Float]
    def to_f
      p = FFI::MemoryPointer.new(:double)
      if CF.CFNumberGetValue(self, :kCFNumberDoubleType, p) == 0
        raise "CF.CFNumberGetValue failed to convert #{inspect} to kCFNumberDoubleType"
      end

      p.read_double
    end
  end
end
