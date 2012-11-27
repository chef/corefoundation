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

  context 'with a 8bit string' do
    it 'should be binary' do
      '123'.binary!.binary?.should be_true
      if CF::String::HAS_ENCODING
        '123'.encode(Encoding::ASCII_8BIT).binary?.should be_true
      else
        "\xff\xff\xff".binary?.should be_true
      end
      [0xff, 0xff, 0xff].pack("C*").binary?.should be_true
    end

    it 'should return a cf data' do
      if CF::String::HAS_ENCODING
        '123'.encode(Encoding::ASCII_8BIT).to_cf.should be_a(CF::Data)
      end
      '123'.binary!.to_cf.should be_a(CF::Data)
      [0xff, 0xff, 0xff].pack("C*").to_cf.should be_a(CF::Data)
    end

    it 'should return nil on garbage binary data flagged as text' do
      [0xff, 0xff, 0xff].pack("C*").binary!(false).to_cf.should be_nil
    end

    # the word "über" in utf-8
    uber = [195, 188, 98, 101, 114]
    it 'should convert utf-8 to cf string' do
      uber.pack("C*").binary!(false).to_cf.should be_a(CF::String)
      if CF::String::HAS_ENCODING
        uber.pack("C*").force_encoding("UTF-8").to_cf.should be_a(CF::String)
      end
    end
    it 'should convert utf-8 flagged as binary to cf data' do
      uber.pack("C*").binary!.to_cf.should be_a(CF::Data)
    end

  end

  context 'with an asciistring' do
    it 'should be non-binary' do
      '123'.binary?.should be_false
    end
    it 'can round-trip' do
      '123'.binary!(true).binary!(false).binary?.should be_false
    end
    it 'should return a cf string' do
      '123'.to_cf.should be_a(CF::String)
      '123'.to_cf_string.should be_a(CF::String)
    end
    it 'should return cf data if asked nicely' do
      '123'.to_cf_data.should be_a(CF::Data)
      '123'.binary!.to_cf.should be_a(CF::Data)
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
