# frozen_string_literal: true

module CF
  attach_variable 'kCFNull', :pointer

  # Wrapper class for the cf null class
  class Null < Base
    register_type 'CFNull'
  end

  # The singleton CFNull instance
  NULL = Null.new(CF.kCFNull)
end
