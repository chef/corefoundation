# frozen_string_literal: true

module CF
  # REVIEW: Add patches as module and wrap them into CoreExtensions module.
  #   This avoids opening ruby core classes and keeps the patches modularized.
  #   Patches are then included in their respective core classes directly in a single place
  #   making it easier to track and toggle the patches for the core classes.
  module CoreExtensions
    # Patches for ruby Integer
    module Integer
      # Converts the Integer to a {CF::Number} using {CF::Number.from_i}
      # @return [CF::Number]
      def to_cf
        CF::Number.from_i(self)
      end
    end

    # Patches for ruby Float
    module Float
      # Converts the Float to a {CF::Number} using {CF::Number.from_f}
      # @return [CF::Number]
      def to_cf
        CF::Number.from_f(self)
      end
    end

    # Patches for ruby Array
    module Array
      # Converts the Array to an immutable {CF::Array} by calling `to_cf` on each element it contains
      # @return [CF::Number]
      def to_cf
        CF::Array.immutable(collect(&:to_cf))
      end
    end

    # Patches for ruby TrueClass
    module TrueClass
      # Returns a CF::Boolean object representing true
      # @return [CF::Boolean]
      def to_cf
        CF::Boolean::TRUE
      end
    end

    # Patches for ruby FalseClass
    module FalseClass
      # Returns a CF::Boolean object representing false
      # @return [CF::Boolean]
      def to_cf
        CF::Boolean::FALSE
      end
    end

    # Patches for ruby String
    module String
      # Returns a {CF::String} or {CF::Data} representing the string.
      # If {#binary?} returns true a {CF::Data} is returned, if not a {CF::String} is returned
      #
      # If you want a {CF::Data} with the contents of a non binary string, use {#to_cf_data}
      #
      # @return [CF::String, CF::Data]
      def to_cf
        binary? ? to_cf_data : to_cf_string
      end

      # @!method binary?
      #
      # used to determine whether {#to_cf} should return a {CF::String} or a {CF::Data}.
      # This simply checks whether the encoding is ascii-8bit or not.
      #
      # @return whether the string is handled as binary data or not
      #
      def binary?
        encoding == Encoding::ASCII_8BIT
      end

      # @param [optional, Boolean, Encoding] bin
      # If you pass `true` then `Encoding::ASCII_BIT` is used, if you pass `false` then `Encoding::UTF_8`
      def binary!(bin = true)
        if bin == true
          force_encoding Encoding::ASCII_8BIT
        else
          # default to utf-8
          force_encoding(bin == false ? "UTF-8" : bin)
        end
        self
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

    # Patches for ruby Time
    module Time
      # Returns a {CF::Date} representing the time.
      # @return [CF::Date]
      def to_cf
        CF::Date.from_time(self)
      end
    end

    # Patches for ruby Hash
    module Hash
      # Converts the Hash to an mutable {CF::Dictionary} by calling `to_cf` on each key and value it contains
      # @return [CF::Dictionary]
      def to_cf
        transform_keys! &:to_s # Convert all keys to strings
        CF::Dictionary.mutable.tap do |r|
          each do |k, v|
            r[k.to_cf] = v.to_cf
          end
        end
      end
    end
  end
end
