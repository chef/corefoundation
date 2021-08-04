module CF
  module Exceptions
    # Raised when the preference value couldn't be found for a domain.
    class PreferenceDoesNotExist < RuntimeError
      def initialize(key, domain, hostname)
        super("Returned NULL value for \"#{key}\" in \"#{domain}\", hostname: #{hostname}")
      end
    end
    # Raised when the preference value failed to write.
    class PreferenceSyncFailed < RuntimeError
      def initialize(key, domain, hostname)
        super("Couldn't write preference value for \"#{key}\" in \"#{domain}\", hostname: #{hostname}")
      end
    end
  end
end
