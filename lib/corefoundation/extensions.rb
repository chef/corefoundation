# Rubyinteger
class Integer
  # Converts the Integer to a {CF::Number} using {CF::Number.from_i}
  # @return [CF::Number]
  def to_cf
    CF::Number.from_i(self)
  end
end

# Ruby float class
class Float
  # Converts the Float to a {CF::Number} using {CF::Number.from_f}
  # @return [CF::Number]
  def to_cf
    CF::Number.from_f(self)
  end
end

# Ruby array class
class Array
  # Converts the Array to an immutable {CF::Array} by calling `to_cf` on each element it contains
  # @return [CF::Number]
  def to_cf
    CF::Array.immutable(collect(&:to_cf))
  end
end

# Ruby true class
class TrueClass
  # Returns a CF::Boolean object representing true
  # @return [CF::Boolean]
  def to_cf
    CF::Boolean::TRUE
  end
end

# Ruby false class
class FalseClass
  # Returns a CF::Boolean object representing false
  # @return [CF::Boolean]
  def to_cf
    CF::Boolean::FALSE
  end
end

# Ruby String class
class String
  # Returns a {CF::String} or {CF::Data} representing the string.
  # If the string has the encoding ASCII_8BIt a {CF::Data} is returned, if not a {CF::String} is returned
  # 
  # @return [CF::String, CF::Data]
  def to_cf
    self.binary? ? self.to_cf_data : self.to_cf_string
  end

  def binary?
    if defined? encoding
      encoding == Encoding::ASCII_8BIT
    else
      unless defined? @cf_is_binary
        begin
          ::Iconv.conv('UTF-8', 'UTF-8', self)
          return false if self.frozen?
          @cf_is_binary = false
        rescue Iconv::IllegalSequence => e
          return true if self.frozen?
          @cf_is_binary = true
        end
      end
      @cf_is_binary
    end
  end

  def binary! bin=true
    if defined? encoding
      if bin != true and encoding == Encoding::ASCII_8BIT
        # default to utf-8
        self.force_encoding( (bin == false) ? "UTF-8" : bin)
      else
        self.force_encoding Encoding::ASCII_8BIT
      end
    else
      @cf_is_binary = !! bin
    end
    self
  end
  
  def to_cf_string
    CF::String.from_string self
  end
  
  def to_cf_data
    CF::Data.from_string self
  end
  
end

# Ruby Time class
class Time
  # Returns a {CF::Date} representing the time.
  # @return [CF::Date]
  def to_cf
    CF::Date.from_time(self)
  end
end

# Ruby Hash class
class Hash
  # Converts the Hash to an mutable {CF::Dictionary} by calling `to_cf` on each key and value it contains
  # @return [CF::Dictionary]
  def to_cf
    CF::Dictionary.mutable.tap do |r|
      each do |k,v|
        r[k.to_cf] = v.to_cf
      end
    end
  end
end
