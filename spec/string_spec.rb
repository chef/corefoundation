# frozen_string_literal: true

require 'spec_helper'

describe CF::String do
  describe 'from_string' do
    it 'should return a CF::String' do
      expect(CF::String.from_string('A CF string')).to be_a(CF::String)
    end

    # The intent is to force feed CF::String with an invalid utf-8 string
    # but jruby doesn't seem to allow this to be constructed
    unless defined? RUBY_ENGINE && (RUBY_ENGINE == 'jruby')
      context 'with invalid data' do
        it 'returns nil' do
          if CF::String::HAS_ENCODING
            expect(CF::String.from_string("\xff\xff\xff".force_encoding('UTF-8'))).to be_nil
          else
            expect(CF::String.from_string("\xff\xff\xff")).to be_nil
          end
        end
      end
    end
  end

  describe '#to_s' do
    it 'should return a utf ruby string' do
      ruby_string = CF::String.from_string('A CF string').to_s
      expect(ruby_string).to eq('A CF string')
      expect(ruby_string.encoding).to eq(Encoding::UTF_8) if CF::String::HAS_ENCODING
    end
  end

  describe 'to_ruby' do
    it 'should behave like to_s' do
      expect(CF::String.from_string('A CF string').to_ruby).to eq('A CF string')
      expect(CF::String.from_string('A CF string').to_ruby.encoding).to eq(Encoding::UTF_8) if CF::String::HAS_ENCODING
    end
  end

  it 'should be comparable' do
    expect(CF::String.from_string('aaa')).to be <= CF::String.from_string('zzz')
  end
end
