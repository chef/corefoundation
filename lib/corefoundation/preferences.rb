module CF
  typedef :pointer, :cfpropertylistref
  typedef :cfstringref, :key
  typedef :cfstringref, :application_id
  typedef :cfstringref, :username
  typedef :cfstringref, :hostname
  typedef :cfpropertylistref, :value

  attach_variable 'kCFPreferencesCurrentUser', :cfstringref
  attach_variable 'kCFPreferencesAnyUser', :cfstringref
  attach_variable 'kCFPreferencesCurrentHost', :cfstringref
  attach_variable 'kCFPreferencesAnyHost', :cfstringref

  attach_function 'CFPreferencesCopyAppValue', [:key, :application_id], :cfpropertylistref
  attach_function 'CFPreferencesCopyValue', [:key, :application_id, :username, :hostname], :cfpropertylistref

  attach_function 'CFPreferencesSetAppValue', [:key, :value, :application_id], :void
  attach_function 'CFPreferencesSetValue', [:key, :value, :application_id, :username, :hostname], :void

  attach_function 'CFPreferencesAppSynchronize', [:application_id], :bool

  # Interface to the preference utilities from Corefoundation.framework.
  # Documentation at https://developer.apple.com/documentation/corefoundation/preferences_utilities
  #
  class Preferences
    using CF::Refinements

    CURRENT_USER = CF.kCFPreferencesCurrentUser
    ALL_USERS = CF.kCFPreferencesAnyUser
    CURRENT_HOST = CF.kCFPreferencesCurrentHost
    ALL_HOSTS = CF.kCFPreferencesAnyHost

    class << self
      # Returns the output from `CFPreferencesCopyValue` call after converting it to ruby type.
      #
      # @param [String] key Preference key to read
      # @param [String] application_id Preference domain for the key
      # @param [String, Symbol] username Domain user (current, any or a specific user)
      # @param [String, Symbol] hostname Hostname (current, all hosts or a specific host)
      #
      # @return [VALUE] Preference value returned from the `CFPreferencesCopyValue` call.
      #
      def get(key, application_id, username = nil, hostname = nil)
        plist_ref = if username && hostname
                      CF.CFPreferencesCopyValue(
                        key.to_cf,
                        application_id.to_cf,
                        arg_to_cf(username),
                        arg_to_cf(hostname)
                      )
                    else
                      CF.CFPreferencesCopyAppValue(key.to_cf, application_id.to_cf)
                    end
        CF::Base.typecast(plist_ref).to_ruby unless plist_ref.null?
      end

      # Calls the {#self.get} method and raise a `PreferenceDoesNotExist` error if `nil` is returned.
      #
      # @param [String] key Preference key to read
      # @param [String] application_id Preference domain for the key
      # @param [String, Symbol] username Domain user (current, any or a specific user)
      # @param [String, Symbol] hostname Hostname (current, all hosts or a specific host)
      #
      # @raise [PreferenceDoesNotExist] If returned value is nil.
      #
      # @return [VALUE] Preference value returned from the {#self.get} method call.
      #
      def get!(key, application_id, username = nil, hostname = nil)
        value = get(key, application_id, username, hostname)
        if value.nil?
          raise(CF::Exceptions::PreferenceDoesNotExist.new(key, application_id, hostname))
        else
          value
        end
      end

      # Set the value for preference domain using `CFPreferencesSetValue`.
      #
      # @param [String] key Preference key
      # @param [Integer, Float, String, TrueClass, FalseClass, Hash, Array] value Preference value
      # @param [String] application_id Preference domain
      # @param [String, Symbol] username Domain user (current, any or a specific user)
      # @param [String, Symbol] hostname Hostname (current, all hosts or a specific host)
      #
      # @return [TrueClass, FalseClass] Returns true if preference was successfully written to storage, otherwise false.
      #
      def set(key, value, application_id, username = nil, hostname = nil)
        if username && hostname
          CF.CFPreferencesSetValue(
            key.to_cf,
            arg_to_cf(value),
            application_id.to_cf,
            arg_to_cf(username),
            arg_to_cf(hostname)
          )
        else
          CF.CFPreferencesSetAppValue(
            key.to_cf,
            arg_to_cf(value),
            application_id.to_cf
          )
        end
        CF.CFPreferencesAppSynchronize(application_id.to_cf)
      end

      # Calls the {#self.set} method and raise a `PreferenceSyncFailed` error if `false` is returned.
      #
      # @param [String] key Preference key to write
      # @param [String] application_id Preference domain for the key
      # @param [String, Symbol] username Domain user (current, any or a specific user)
      # @param [String, Symbol] hostname Hostname (current, all hosts or a specific host)
      #
      # @raise [PreferenceSyncFailed] If {#self.set} call returned false.
      #
      # @return [VALUE] Returns nil if preference value is successfully written.
      #
      def set!(key, value, application_id, username = nil, hostname = nil)
        raise(CF::Exceptions::PreferenceSyncFailed.new(key, application_id, hostname)) unless set(key, value, application_id, username, hostname)
      end

      private
      # Convert an object from ruby to cf type.
      #
      # @param [VALUE, CFType] arg A ruby or corefoundation object.
      #
      # @return [CFType] A wrapped CF object.
      #
      # @visiblity private
      def arg_to_cf(arg)
        arg.respond_to?(:to_cf) ? arg.to_cf : arg
      end
    end
  end
end
