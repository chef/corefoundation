# -*- coding: utf-8 -*-
require 'spec_helper'

describe CF::Refinements do
  using described_class
  context 'with an integer' do
    it 'should return a cfnumber' do
      expect(1.to_cf).to be_a(CF::Number)
    end
  end

  context 'with a float' do
    it 'should return a cfnumber' do
      expect(1.0.to_cf).to be_a(CF::Number)
    end
  end

  describe String do
    uber = [195, 188, 98, 101, 114]

    unless defined? RUBY_ENGINE and RUBY_ENGINE == 'jruby'
      context 'with data incorrectly marked as non binary' do
        it 'returns nil' do
          expect([0xff, 0xff, 0xff].pack('C*').binary!(false).to_cf).to be_nil
        end
      end
    end

    context 'with a non binary string' do
      it 'should return a cf string' do
        expect('123'.to_cf).to be_a(CF::String)
      end
    end
    
    context 'with a string marked as binary' do
      it 'should return a cf data' do
        expect('123'.binary!.to_cf).to be_a(CF::Data)
      end
    end
    
    context 'with a binary string' do    
      it 'should return a cf data' do
        expect([0xff, 0xff, 0xff].pack('C*').to_cf).to be_a(CF::Data)
      end
    end
    
    context 'with a utf-8 string' do
      it 'should return a cfstring' do
        expect(uber.pack('C*')).not_to be_a(CF::String)
      end
    end

    context 'binary?' do
      it 'should return false on a plain ascii string' do
        expect('123'.binary?).to eq false
      end
      
      it "should return false on valid utf data" do
        expect("\xc3\xc9".binary?).to eq false
      end
      
      it 'should return false on string forced to non binary' do
        expect("\xc3\xc9".binary!(false).binary?).to eq false
      end
      
      it 'should return true if binary! has been called' do
        expect('123'.binary!.binary?).to eq true
      end
      
      it "should return true for ascii 8bit strings" do
        expect("123".encode(Encoding::ASCII_8BIT).binary?).to eq true
      end
    end
  end
  
  describe FalseClass do
    context 'with false' do
      it 'should return CF::Boolean::FALSE' do
        expect(false.to_cf).to eq(CF::Boolean::FALSE)
      end
    end
  end
  
  describe TrueClass do
    context 'with true' do
      it 'should return CF::Boolean::TRUE' do
        expect(true.to_cf).to eq(CF::Boolean::TRUE)
      end
    end
  end
  
  describe Time do
    context 'with a time' do
      it 'should return a CFDate' do
        expect(Time.now.to_cf).to be_a(CF::Date)
      end
    end
  end

  describe Array do
    context 'with an array' do
      it 'should return a cfarray containing cf objects' do
        cf_array = [true, 1, 'hello'].to_cf
        expect(cf_array).to be_a(CF::Array)
        expect(cf_array[0]).to eq(CF::Boolean::TRUE)
        expect(cf_array[1]).to be_a(CF::Number)
        expect(cf_array[2]).to eq(CF::String.from_string('hello'))
      end
    end
  end
    
  
  describe Hash do
    context 'with a dictionary' do
      it 'should return a cfdictionary containing cf objects' do
        cf_hash = { 'key_1' => true, 'key_2' => false }.to_cf
        expect(cf_hash['key_1']).to eq(CF::Boolean::TRUE)
        expect(cf_hash['key_2']).to eq(CF::Boolean::FALSE)
      end
    end
    context "to_cf" do
      it 'should return a CF::Dictionary' do
        input = { "key1": "value", :key2 => "value2" }
        expect(input.to_cf).to be_a CF::Dictionary
      end
    end
  end
end

