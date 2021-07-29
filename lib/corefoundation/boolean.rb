module CF
  attach_variable "kCFBooleanTrue", :pointer
  attach_variable "kCFBooleanFalse", :pointer
  attach_function "CFBooleanGetValue", [:pointer], :uchar

  # Wrapper for CFBooleanRef.
  # Typically you use the CF::Boolean::TRUE and CF::Boolean::FALSE constants
  #
  class Boolean < Base
    register_type("CFBoolean")
    # A constant containing kCFBooleanTrue
    TRUE = new(CF.kCFBooleanTrue)
    # A constant containing kCFBooleanFalse
    FALSE = new(CF.kCFBooleanFalse)

    # returns a ruby true/false value
    #
    # @return [Boolean]
    def value
      CF.CFBooleanGetValue(self) != 0
    end

    alias to_ruby value
  end
end
