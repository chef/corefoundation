# Maps Preferences Utilities
# Documentation at https://developer.apple.com/documentation/corefoundation/preferences_utilities

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

  class Preferences
    CURRENT_USER = CF.kCFPreferencesCurrentUser
    ALL_USERS = CF.kCFPreferencesAnyUser
    CURRENT_HOST = CF.kCFPreferencesCurrentHost
    ALL_HOSTS = CF.kCFPreferencesAnyHost

    class << self
      def get(key, application_id, username = nil, hostname = nil)
        # TODO: Check usecase for `CFPreferencesCopyAppValue`

        plist_ref = if username && hostname
                      CF.CFPreferencesCopyValue(key.to_cf, application_id.to_cf, arg_to_cf(username),
                                                arg_to_cf(hostname))
                    else
                      CF.CFPreferencesCopyAppValue(key.to_cf, application_id.to_cf)
                    end
        CF::Base.typecast(plist_ref).to_ruby unless plist_ref.null?
      end

      def get!(key, application_id, username = nil, hostname = nil)
        get(key, application_id, username, hostname) || (raise CF::Error, "Preference key `#{key}` not found")
      end

      def set(key, value, application_id, username = CURRENT_USER, hostname = CURRENT_HOST)
        CF.CFPreferencesSetValue(key.to_cf, value.to_cf, application_id.to_cf, arg_to_cf(username), arg_to_cf(hostname))
        CF.CFPreferencesAppSynchronize(application_id.to_cf)
      end

      def list_keys(application_id, username, hostname)
        arr_ref = CF.CFPreferencesCopyKeyList(
          application_id.to_cf,
          arg_to_cf(username),
          arg_to_cf(hostname)
        )
        CF::Array.new(arr_ref).to_ruby
      end

      private

      # Check for constants CURRENT_USER, ALL_HOSTS etc.
      def arg_to_cf(arg)
        arg.respond_to?(:to_cf) ? arg.to_cf : arg
      end
    end
  end
end
