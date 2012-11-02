module CF
  attach_variable 'kCFBooleanTrue', :pointer
  attach_variable 'kCFBooleanFalse', :pointer
  attach_function 'CFBooleanGetValue', [:pointer], :uchar
  class Boolean < Base
    register_type("CFBoolean")
    TRUE = new(CF.kCFBooleanTrue)
    FALSE = new(CF.kCFBooleanFalse)
    def value
      CF.CFBooleanGetValue(self) != 0
    end

    alias_method :to_ruby, :value
  end
end