require "spec_helper"

describe CF::Preferences do

  before do
    @domain = "test.app.domain"
    @cf_domain = @domain.to_cf
    @key = "testkey"
    @cf_key = @key.to_cf
    @user = "testuser"
    @cf_user = @user.to_cf
    @hostname = "Test-HostName.local"
    @cf_hostname = @hostname.to_cf
    @value = "testvalue"
    @cf_value = @value.to_cf
  end

  let(:copy_app_value_valid) { double("CF.CFPreferencesCopyAppValue", result: @cf_value.ptr) }
  let(:copy_app_value_nil) { double("CF.CFPreferencesCopyAppValue", result: CF::NULL) }
  let(:copy_value_valid) { double("CF.CFPreferencesCopyValue", result: @cf_value.ptr) }
  let(:copy_value_nil) { double("CF.CFPreferencesCopyValue", result: CF::NULL) }
  let(:set_app_value) { double("CF.CFPreferencesSetAppValue", result: nil) }
  let(:set_value) { double("CF.CFPreferencesSetValue", result: nil) }
  let(:pref_sync_passed) { double("CF.CFPreferencesAppSynchronize", result: true) }
  let(:pref_sync_failed) { double("CF.CFPreferencesAppSynchronize", result: false) }

  describe "self.set" do
    context "when called with valid domain/default pair" do
      context "(with username and hostname)" do
        it "executes CF.CFPreferencesSetValue and returns true" do
          expect(CF).to receive(:CFPreferencesSetValue).with(@cf_key, @cf_value, @cf_domain, @cf_user, @cf_hostname)
          expect(CF).to receive(:CFPreferencesAppSynchronize).with(@cf_domain).and_return(pref_sync_passed.result)
          expect(CF::Preferences.set(@key, @value, @domain, @user, @hostname)).to eql(true)
        end
      end
      context "(without username and hostname)" do
        it "executes CF.CFPreferencesSetAppValue and returns true" do
          expect(CF).to receive(:CFPreferencesSetAppValue).with(@cf_key, @cf_value, @cf_domain)
          expect(CF).to receive(:CFPreferencesAppSynchronize).with(@cf_domain).and_return(pref_sync_passed.result)
          expect(CF::Preferences.set(@key, @value, @domain)).to eql(true)
        end
      end
    end
    context "when called with invalid domain/default pair" do
      context "(with username and hostname)" do
        it "executes CF.CFPreferencesSetValue and returns false" do
          expect(CF).to receive(:CFPreferencesSetValue).with(@cf_key, @cf_value, @cf_domain, @cf_user, @cf_hostname)
          expect(CF).to receive(:CFPreferencesAppSynchronize).with(@cf_domain).and_return(pref_sync_failed.result)
          expect(CF::Preferences.set(@key, @value, @domain, @user, @hostname)).to eql(false)
        end
      end
      context "(without username and hostname)" do
        it "executes CF.CFPreferencesSetAppValue and returns false" do
          expect(CF).to receive(:CFPreferencesSetAppValue).with(@cf_key, @cf_value, @cf_domain)
          expect(CF).to receive(:CFPreferencesAppSynchronize).with(@cf_domain).and_return(pref_sync_failed.result)
          expect(CF::Preferences.set(@key, @value, @domain)).to eql(false)
        end
      end
    end
  end

  describe "self.set!" do
    context "when called with valid domain/default pair" do
      context "(with username and hostname)" do
        it "executes CF.CFPreferencesSetValue and returns nil" do
          expect(CF).to receive(:CFPreferencesSetValue).with(@cf_key, @cf_value, @cf_domain, @cf_user, @cf_hostname)
          expect(CF).to receive(:CFPreferencesAppSynchronize).with(@cf_domain).and_return(pref_sync_passed.result)
          expect(CF::Preferences.set!(@key, @value, @domain, @user, @hostname)).to eql(nil)
        end
      end
      context "(without username and hostname)" do
        it "executes CF.CFPreferencesSetAppValue and returns nil" do
          expect(CF).to receive(:CFPreferencesSetAppValue).with(@cf_key, @cf_value, @cf_domain)
          expect(CF).to receive(:CFPreferencesAppSynchronize).with(@cf_domain).and_return(pref_sync_passed.result)
          expect(CF::Preferences.set!(@key, @value, @domain)).to eql(nil)
        end
      end
    end
    context "when called with invalid domain/default pair" do
      context "(with username and hostname)" do
        it "executes CF.CFPreferencesSetValue and raises error" do
          expect(CF).to receive(:CFPreferencesSetValue).with(@cf_key, @cf_value, @cf_domain, @cf_user, @cf_hostname)
          expect(CF).to receive(:CFPreferencesAppSynchronize).with(@cf_domain).and_return(pref_sync_failed.result)
          expect { CF::Preferences.set!(@key, @value, @domain, @user, @hostname) }.to raise_error CF::Exceptions::PreferenceSyncFailed
        end
      end
      context "(without username and hostname)" do
        it "executes CF.CFPreferencesSetAppValue and raises error" do
          expect(CF).to receive(:CFPreferencesSetAppValue).with(@cf_key, @cf_value, @cf_domain)
          expect(CF).to receive(:CFPreferencesAppSynchronize).with(@cf_domain).and_return(pref_sync_failed.result)
          expect { CF::Preferences.set!(@key, @value, @domain) }.to raise_error CF::Exceptions::PreferenceSyncFailed
        end
      end
    end
  end

  describe "self.get" do
    context "when called with valid domain/default pair" do
      context "(with username and hostname)" do
        it "executes CF.CFPreferencesCopyValue and returns value" do
          expect(CF).to receive(:CFPreferencesCopyValue).with(@cf_key, @cf_domain, @cf_user, @cf_hostname).and_return(copy_value_valid.result)
          expect(CF::Preferences.get(@key, @domain, @user, @hostname)).to eql(@value)
        end
      end
      context "(without username and hostname)" do
        it "executes CF.CFPreferencesCopyAppValue and returns value" do
          expect(CF).to receive(:CFPreferencesCopyAppValue).with(@cf_key, @cf_domain).and_return(copy_app_value_valid.result)
          expect(CF::Preferences.get(@key, @domain)).to eql(@value)
        end
      end
    end
    context "when called with invalid domain/default pair" do
      context "(with username and hostname)" do
        it "executes CF.CFPreferencesCopyValue and returns nil" do
          expect(CF).to receive(:CFPreferencesCopyValue).with(@cf_key, @cf_domain, @cf_user, @cf_hostname).and_return(copy_value_nil.result)
          expect(CF::Preferences.get(@key, @domain, @user, @hostname)).to eql(nil)
        end
      end
      context "(without username and hostname)" do
        it "executes CF.CFPreferencesCopyAppValue and returns nil" do
          expect(CF).to receive(:CFPreferencesCopyAppValue).with(@cf_key, @cf_domain).and_return(copy_app_value_nil.result)
          expect(CF::Preferences.get(@key, @domain)).to eql(nil)
        end
      end
    end
  end

  describe "self.get!" do
    context "when called with valid domain/default pair" do
      context "(with username and hostname)" do
        it "executes CF.CFPreferencesCopyValue and returns value" do
          expect(CF).to receive(:CFPreferencesCopyValue).with(@cf_key, @cf_domain, @cf_user, @cf_hostname).and_return(copy_value_valid.result)
          expect(CF::Preferences.get!(@key, @domain, @user, @hostname)).to eql(@value)
        end
      end
      context "(without username and hostname)" do
        it "executes CF.CFPreferencesCopyAppValue and returns value" do
          expect(CF).to receive(:CFPreferencesCopyAppValue).with(@cf_key, @cf_domain).and_return(copy_app_value_valid.result)
          expect(CF::Preferences.get!(@key, @domain)).to eql(@value)
        end
      end
    end
    context "when called with invalid domain/default pair" do
      context "(with username and hostname)" do
        it "executes CF.CFPreferencesCopyValue and raises error" do
          expect(CF).to receive(:CFPreferencesCopyValue).with(@cf_key, @cf_domain, @cf_user, @cf_hostname).and_return(copy_value_nil.result)
          expect { CF::Preferences.get!(@key, @domain, @user, @hostname) }.to raise_error CF::Exceptions::PreferenceDoesNotExist
        end
      end
      context "(without username and hostname)" do
        it "executes CF.CFPreferencesCopyAppValue and raises error" do
          expect(CF).to receive(:CFPreferencesCopyAppValue).with(@cf_key, @cf_domain).and_return(copy_app_value_nil.result)
          expect { CF::Preferences.get!(@key, @domain) }.to raise_error CF::Exceptions::PreferenceDoesNotExist
        end
      end
    end
  end

end
