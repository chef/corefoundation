module CF
  typedef :pointer, :cfpropertylistref
  typedef :cfstringref, :key
  typedef :cfstringref, :application_id
  typedef :cfstringref, :username
  typedef :cfstringref, :hostname
  typedef :cfpropertylistref, :value

  attach_variable "kCFPreferencesCurrentUser", :cfstringref
  attach_variable "kCFPreferencesAnyUser", :cfstringref
  attach_variable "kCFPreferencesCurrentHost", :cfstringref
  attach_variable "kCFPreferencesAnyHost", :cfstringref
  attach_variable "kCFPreferencesAnyApplication", :cfstringref

  attach_function "CFPreferencesCopyAppValue", %i{key application_id}, :cfpropertylistref
  attach_function "CFPreferencesCopyValue", %i{key application_id username hostname}, :cfpropertylistref
  attach_function "CFPreferencesCopyKeyList", %i{application_id username hostname}, :cfarrayref

  attach_function "CFPreferencesSetAppValue", %i{key value application_id}, :void
  attach_function "CFPreferencesSetValue", %i{key value application_id username hostname}, :void
  attach_function "CFPreferencesAppSynchronize", [:application_id], :bool

  # Interface to the preference utilities from Corefoundation.framework.
  # Documentation at https://developer.apple.com/documentation/corefoundation/preferences_utilities
  #
  class Preferences
    CURRENT_USER = CF.kCFPreferencesCurrentUser
    ALL_USERS = CF.kCFPreferencesAnyUser
    CURRENT_HOST = CF.kCFPreferencesCurrentHost
    ALL_HOSTS = CF.kCFPreferencesAnyHost

    # Returns the output from `CFPreferencesCopyValue` call after converting it to ruby type.
    #
    # @param [String] key Preference key to read
    # @param [String] application_id Preference domain for the key
    # @param [String, Symbol] username Domain user (current, any or a specific user)
    # @param [String, Symbol] hostname Hostname (current, all hosts or a specific host)
    #
    # @return [VALUE] Preference value returned from the `CFPreferencesCopyValue` call.
    #
    def self.get(key, application_id, username = nil, hostname = nil)
      username ||= CURRENT_USER
      hostname ||= ALL_HOSTS
      plist_ref = CF.CFPreferencesCopyValue(
        key.to_cf,
        application_id.to_cf,
        arg_to_cf(username),
        arg_to_cf(hostname)
      )
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
    def self.get!(key, application_id, username = nil, hostname = nil)
      hostname = arg_to_cf(hostname || ALL_HOSTS)
      hostname = CF::Base.typecast(hostname).to_ruby
      get(key, application_id, username, hostname) ||
        raise(CF::Exceptions::PreferenceDoesNotExist.new(key, application_id, hostname))
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
    def self.set(key, value, application_id, username = nil, hostname = nil)
      username ||= CURRENT_USER
      hostname ||= ALL_HOSTS
      CF.CFPreferencesSetValue(key.to_cf, arg_to_cf(value), application_id.to_cf, arg_to_cf(username), arg_to_cf(hostname))
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
    # @return [VALUE] Returns true if preference value is successfully written.
    #
    def self.set!(key, value, application_id, username = nil, hostname = nil)
      hostname = arg_to_cf(hostname || ALL_HOSTS)
      hostname = CF::Base.typecast(hostname).to_ruby
      raise(CF::Exceptions::PreferenceSyncFailed.new(key, application_id, hostname)) unless set(key, value, application_id, username, hostname)
    end

    # Checks whether a key exists in the preference domain. It'll also return false for an invalid domain.
    #
    # @param [String] key Preference key to read
    # @param [String] application_id Preference domain for the key
    # @param [String, Symbol] username Domain user (current, any or a specific user)
    # @param [String, Symbol] hostname Hostname (current, all hosts or a specific host)
    #
    # @return [TrueClass, FalseClass] Return true or false to indicate if it is a valid key.
    #
    def self.valid_key?(key, application_id, username = nil, hostname = nil)
      domain_keys = list_keys(application_id, username, hostname)
      domain_keys.include?(key)
    end

    private

    # Get all existing keys for a preference domain.
    #
    # @param [String] application_id Preference domain for the key
    # @param [String, Symbol] username Domain user (current, any or a specific user)
    # @param [String, Symbol] hostname Hostname (current, all hosts or a specific host)
    #
    # @return [Array<String>] Array of key names
    #
    # @visiblity private
    def self.list_keys(application_id, username = nil, hostname = nil)
      username ||= CURRENT_USER
      hostname ||= ALL_HOSTS
      arr_ref = CF.CFPreferencesCopyKeyList(
        application_id.to_cf,
        arg_to_cf(username),
        arg_to_cf(hostname)
      )
      arr_ref.null? ? [] : CF::Array.new(arr_ref).to_ruby
    end

    # Convert an object from ruby to cf type.
    #
    # @param [VALUE, CFType] arg A ruby or corefoundation object.
    #
    # @return [CFType] A wrapped CF object.
    #
    # @visiblity private
    def self.arg_to_cf(arg)
      arg.respond_to?(:to_cf) ? arg.to_cf : arg
    end
  end
end
