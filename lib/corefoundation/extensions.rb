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
  # If {#binary?} returns true a {CF::Data} is returned, if not a {CF::String} is returned
  # 
  # If you want a {CF::Data} with the contents of a non binary string, use {#to_cf_data}
  #
  # @return [CF::String, CF::Data]
  def to_cf
    self.binary? ? self.to_cf_data : self.to_cf_string
  end

  # @!method binary?
  #
  # used to determine whether {#to_cf} should return a {CF::String} or a {CF::Data}. On ruby 1.9 and above this simply 
  # checks whether the encoding is ascii-8bit or not.
  # 
  # On ruby 1.8.7
  #
  # - A string is binary if you call {#binary!} with the default argument of true
  # - A string is not binary if you call {#binary!} with the argument false
  # 
  # If you have never called {#binary!} then a string is binary if Iconv does not think it is valid utf-8
  # @return whether the string is handled as binary data or not
  #
  if '<3'.respond_to? :encoding
    def binary?
      encoding == Encoding::ASCII_8BIT
    end
  else
    def binary?
      unless defined? @cf_is_binary
        begin
          ::Iconv.conv('UTF-8', 'UTF-8', self)
          return false if self.frozen?
          @cf_is_binary = false
        rescue Iconv::IllegalSequence
          return true if self.frozen?
          @cf_is_binary = true
        end
      end
      @cf_is_binary
    end
  end

  if '<3'.respond_to? :encoding
  # On ruby 1.8.7 sets or clears the flag used by {#binary?}. On ruby 1.9 the string's encoding is forced. 
  # @see #binary?
  # 
  # @note There is no advantage to using this over the standard encoding methods unless you wish to retain 1.8.7 compatibility
  #
  # @param [optional, Boolean, Encoding] bin On ruby 1.8.7 only boolean values are admissible. On ruby 1.9 you can pass a specific encoding to force. 
  #   If you pass `true` then `Encoding::ASCII_BIT` is used, if you pass `false` then `Encoding::UTF_8`
  #
    def binary!(bin=true)
      if bin == true
        self.force_encoding Encoding::ASCII_8BIT
      else
        # default to utf-8
        self.force_encoding( (bin == false) ? "UTF-8" : bin)
      end
      self
    end
  else
  # On ruby 1.8.7 sets or clears the flag used by {#binary?}. On ruby 1.9 the string's encoding is forced. 
  # @see #binary?
  # 
  # @note There is no advantage to using this over the standard encoding methods unless you wish to retain 1.8.7 compatibility
  #
  # @param [optional, Boolean, Encoding] bin On ruby 1.8.7 only boolean values are admissible. On ruby 1.9 you can pass a specific encoding to force. 
  #   If you pass `true` then `Encoding::ASCII_BIT` is used, if you pass `false` then `Encoding::UTF_8`
  #
    def binary!(bin=true)
      @cf_is_binary = !! bin
      self
    end
  end
  
  # Returns a {CF::String} representing the string
  # @return [CF::String]
  def to_cf_string
    CF::String.from_string self
  end
  
  # Returns a {CF::Data} representing the string
  # @return [CF::Data]
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
