# Maps Preferences Utilities
# Documentation at https://developer.apple.com/documentation/corefoundation/preferences_utilities

module CF
  typedef :pointer, :cfpropertylistref
  typedef :cfstringref, :key
  typedef :cfstringref, :application_id
  typedef :cfpropertylistref, :value

  attach_function 'CFPreferencesCopyAppValue', [:key, :application_id], :cfpropertylistref
  attach_function 'CFPreferencesSetAppValue', [:key, :value, :application_id], :void
  attach_function 'CFPreferencesAppSynchronize', [:application_id], :bool

  class Preferences
    class << self
      def get(key, application_id)
        plist_ref = CF.CFPreferencesCopyAppValue(
          key.to_cf,
          application_id.to_cf
        )
        CF::Base.typecast(plist_ref).to_ruby
      end

      def set(key, value, application_id)
        CF.CFPreferencesSetAppValue(
          key.to_cf,
          value.to_cf,
          application_id.to_cf
        )
        CF.CFPreferencesAppSynchronize(application_id.to_cf)
      end
    end
  end
end
