# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'extensions' do
  context 'with an integer' do
    it 'should return a cfnumber' do
      1.to_cf.should be_a(CF::Number)
    end
  end

  context 'with a float' do
    it 'should return a cfnumber' do
      (1.0).to_cf.should be_a(CF::Number)
    end
  end

  describe String do
    uber = [195, 188, 98, 101, 114]
    
    describe 'to_cf' do

      unless defined? RUBY_ENGINE and RUBY_ENGINE == 'jruby'
        context 'with data incorrectly marked as non binary' do
          it 'returns nil' do
            [0xff, 0xff, 0xff].pack("C*").binary!(false).to_cf.should be_nil
          end
        end
      end

      context 'with a non binary string' do
        it 'should return a cf string' do
          '123'.to_cf.should be_a(CF::String)
        end
      end

      context 'with a string marked as binary' do
        it 'should return a cf data' do
          '123'.binary!.to_cf.should be_a(CF::Data)
        end
      end

      context 'with a binary string' do    
        it 'should return a cf data' do
          [0xff, 0xff, 0xff].pack("C*").to_cf.should be_a(CF::Data)
        end
      end

      context 'with a utf-8 string' do
        it 'should return a cfstring' do
          uber.pack("C*").should_not be_a(CF::String)
        end
      end
    end

    describe 'binary?' do

      it 'should return false on a plain ascii string' do
        '123'.should_not be_binary
      end

      if CF::String::HAS_ENCODING
        it 'should return false on valid utf data' do
          "\xc3\xc9".should_not be_binary
        end
      else
        it 'should return false on valid utf data' do
          uber.pack("C*").should_not be_binary
        end
      end

      it 'should return false on string forced to non binary' do
        "\xc3\xc9".binary!(false).should_not be_binary
      end

      it 'should return true if binary! has been called' do
        '123'.binary!.should be_binary
      end

      if CF::String::HAS_ENCODING
        it 'should return true for ascii 8bit strings' do
          '123'.encode(Encoding::ASCII_8BIT).should be_binary
        end
      else
        it 'should return true for data that cannot be converted to utf8' do
          "\xff\xff\xff".should be_binary
        end
      end
    end

  end

  context 'with true' do
    it 'should return CF::Boolean::TRUE' do
      true.to_cf.should == CF::Boolean::TRUE
    end
  end

  context 'with false' do
    it 'should return CF::Boolean::FALSE' do
      false.to_cf.should == CF::Boolean::FALSE
    end
  end

  context 'with a time' do
    it 'should return a CFDate' do
      Time.now.to_cf.should be_a(CF::Date)
    end
  end

  context 'with an array' do
    it 'should return a cfarray containing cf objects' do
      cf_array = [true, 1, 'hello'].to_cf
      cf_array.should be_a(CF::Array)
      cf_array[0].should == CF::Boolean::TRUE
      cf_array[1].should be_a(CF::Number)
      cf_array[2].should == CF::String.from_string('hello')
    end
  end

  context 'with a dictionary' do
    it 'should return a cfdictionary containing cf objects' do
      cf_hash = {'key_1' => true, 'key_2' => false}.to_cf
      cf_hash['key_1'].should == CF::Boolean::TRUE
      cf_hash['key_2'].should == CF::Boolean::FALSE
    end
  end
end
