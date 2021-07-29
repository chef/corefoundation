require "spec_helper"

describe CF::Data do
  subject { CF::Data.from_string("A CF string") }
  describe "#to_s" do
    it "should return a binary ruby string" do
      ruby_string = subject.to_s
      expect(ruby_string).to eq("A CF string")
      expect(ruby_string.encoding).to eq(Encoding::ASCII_8BIT) if CF::String::HAS_ENCODING
    end
  end

  describe "#size" do
    it "should return the size in bytes of the cfdata" do
      expect(subject.size).to eq(11)
    end
  end

  describe "to_ruby" do
    it "should behave like to_s" do
      expect(subject.to_ruby).to eq("A CF string")
      expect(subject.to_ruby.encoding).to eq(Encoding::ASCII_8BIT) if "A CF string".respond_to? "encoding"
    end
  end
end
