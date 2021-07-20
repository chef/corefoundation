# frozen_string_literal: true

module CF
  typedef :pointer, :cfdateref
  typedef :double, :cfabsolutetime

  attach_function :CFDateCreate, %i[pointer cfabsolutetime], :cfdateref
  attach_function :CFDateGetAbsoluteTime, [:cfdateref], :cfabsolutetime
  attach_variable :kCFAbsoluteTimeIntervalSince1970, :double

  # Wrapper for CFDateRef
  #
  #
  class Date < Base
    register_type 'CFDate'

    # constructs a CF::Date from a ruby time
    #
    # @param [Time] time
    # @return [CF::Date] a CF::Date instance that will be released on garbage collection
    def self.from_time(time)
      new(CF.CFDateCreate(nil, time.to_f - CF.kCFAbsoluteTimeIntervalSince1970))
    end

    # returns a ruby Time instance corresponding to the same point in time
    #
    # @return [Time]
    def to_time
      Time.at(CF.CFDateGetAbsoluteTime(self) + CF.kCFAbsoluteTimeIntervalSince1970)
    end

    alias to_ruby to_time
  end
end
