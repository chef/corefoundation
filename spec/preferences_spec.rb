require "spec_helper"

describe CF::Preferences do
  before do
    @validDomain = "TestValidDomain"
    @invalidDomain = "TestInvalidDomain"
    @validKey = "ValidTestKey"
    @invalidKey = "InvalidTestKey"
    @value = "TestValue"
  end

  after(:each) do
    CF::Preferences.set!(@validKey, nil, @validDomain)
    CF::Preferences.set!(@invalidKey, nil, @validDomain)
  end

  describe "self.set" do
    context "when called with valid domain/default pair" do
      it "writes correct value and returns true" do
        expect(CF::Preferences.set(@validKey, @value, @validDomain)).to eq true
        expect(CF::Preferences.get(@validKey, @validDomain)).to eq @value
      end
    end
  end

  describe "self.set!" do
    context "when called with valid domain/default pair" do
      it "writes correct value and returns nil" do
        expect(CF::Preferences.set!(@validKey, @value, @validDomain)).to be_nil
        expect(CF::Preferences.get(@validKey, @validDomain)).to eq @value
      end
    end
  end

  describe "self.get" do
    before do
      CF::Preferences.set(@validKey, @value, @validDomain)
    end

    context "when called with valid domain/default pair" do
      it "returns value" do
        expect(CF::Preferences.get(@validKey, @validDomain)).to eq @value
      end
    end

    context "when called with invalid domain/default pair" do  
      it "returns nil" do
        expect(CF::Preferences.get(@validKey, @invalidDomain)).to be_nil
      end
    end
  end

  describe "self.get!" do
    context "when called with valid domain/default pair" do
      it "returns value" do
        expect(CF::Preferences.set!(@validKey, @value, @validDomain)).to be_nil
        expect(CF::Preferences.get!(@validKey, @validDomain)).to eq @value
      end
    end

    context "when called with invalid domain/default pair" do  
      it "raise an error" do
        expect { CF::Preferences.get!(@validKey, @invalidDomain) }.to raise_error CF::Exceptions::PreferenceDoesNotExist
      end
    end
  end
end
