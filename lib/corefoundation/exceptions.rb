module CF
  module Exceptions
    # Raised when abstract method is not overridden
    class MethodNotImplemented < StandardError; end
  end
end
