require "singleton"

module CF
  module Register
    class RegisteredTypes
      include Singleton
      @type_map = {}
    end

    def self.included base
      base.extend self
    end

    def register_type(type_name)
      CF.attach_function "#{type_name}GetTypeID", [], :cftypeid
      types = RegisteredTypes.instance_variable_get(:@type_map)
      types[CF.send("#{type_name}GetTypeID")] = self
      RegisteredTypes.instance_variable_set(:@type_map, types)
    end

    private

    def klass_from_cf_type(cftyperef)
      klass = RegisteredTypes.instance_variable_get(:@type_map)[CF.CFGetTypeID(cftyperef)]
      raise TypeError, "No class registered for cf type #{cftyperef.inspect}" unless klass

      klass
    end

    private_constant :RegisteredTypes
  end
end
