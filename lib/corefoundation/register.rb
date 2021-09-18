require "singleton"

module CF
  module Register
    def self.included base
      base.extend self
    end

    def register_type(type_name)
      CF.attach_function "#{type_name}GetTypeID", [], :cftypeid
      type_map[CF.send("#{type_name}GetTypeID")] = self
    end

    private

    def klass_from_cf_type(cftyperef)
      klass = type_map[CF.CFGetTypeID(cftyperef)]
      raise TypeError, "No class registered for cf type #{cftyperef.inspect}" unless klass

      klass
    end

  end
end
