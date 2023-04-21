require 'spec_helper'
require 'uri'

describe CF::String do
  describe 'from_string' do
    it 'should return a CF::URL' do
      expect(CF::URL.from_string('a/path/to/something')).to be_a(CF::URL)
    end
  end

  describe "#to_s" do
    it "should return a utf ruby string" do
      ruby_string = CF::URL.from_path('a/path/to/something').to_s
      expect(ruby_string).to eq('a/path/to/something')
      expect(ruby_string.encoding).to eq(Encoding::UTF_8)
    end
  end

  describe "to_ruby" do
    it "should behave like to_uri" do
      expect(CF::URL.from_uri(URI('https://example.com')).to_ruby).to eq(URI('https://example.com'))
    end
  end

end
