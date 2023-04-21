# frozen_string_literal: true

require 'uri'

module CF
  typedef :pointer, :cfurlref

  attach_function 'CFURLCreateWithString', [:pointer, :cfstringref, :cfurlref], :cfurlref
  attach_function 'CFURLCreateFromFileSystemRepresentation', [:pointer, :buffer_in, :cfindex, :bool], :cfurlref
  attach_function 'CFURLGetString', [:cfurlref], :cfstringref

  # Wrapper class for CFURL
  class URL < Base
    register_type('CFURL')

    # Creates a CF::URL from a Ruby string
    #
    # @param [String] string
    # @return [CF::URL]
    def self.from_string(string)
      raw = CF.CFURLCreateWithString(nil, CF::String.from_string(string), nil)
      raw.null? ? nil : new(raw)
    end

    def to_s
      CF::String.new(CF.CFURLGetString(self))&.to_s
    end

    # Creates a CF::URL from a Ruby string that represents a filesystem path
    #
    # @param [String] path
    # @return [CF::URL]
    def self.from_path(path)
      s_utf = path.encode('UTF-8')
      raw = CF.CFURLCreateFromFileSystemRepresentation(nil, s_utf, s_utf.bytesize, false)
      raw.null? ? nil : new(raw)
    end

    def self.from_uri(uri)
      from_string(uri.to_s)
    end

    def to_uri
      URI(to_s)
    end
    alias to_ruby to_uri
  end
end
