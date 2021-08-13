module CF
  #
  # Maps to the corefoundation structure CFRange.
  # See usage in CF::Array and CF::String.
  #
  class Range < FFI::Struct
    layout :location, :cfindex,
           :length, :cfindex
  end
end
