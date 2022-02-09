require 'spec_helper'

describe CF::Number do

  describe 'to_ruby' do
    context 'with a number created from a float' do
      subject {CF::Number.from_f('3.1415')} 
      it 'should return a float' do
        expect(subject.to_ruby).to be_within(0.0000001).of(3.14150)
      end
    end
    context 'with a number created from a int' do
      subject {CF::Number.from_i('31415')} 
      it 'should return a int' do
        expect(subject.to_ruby).to eq(31_415)
        expect(subject.to_ruby).to be_a(Integer)
      end
    end
  end

  describe 'comparison operation' do
    it 'should successfully work for CF types' do
      expect(CF::Number.from_f('3.1415') <= CF::Number.from_i(4)).to be true
    end

    it 'should raise TypeError if the input is not CF type' do
      expect { CF::Number.from_f('3.1415') == 3.1415 }.to raise_error(TypeError)
    end
  end

  describe('from_f') do 
    it 'should create a cf number from a float' do
      expect(CF::Number.from_f('3.1415')).to be_a(CF::Number)
    end
  end

  describe('from_i') do 
    it 'should create a cf number from a 32 bit sized int' do
      expect(CF::Number.from_i(2**30)).to be_a(CF::Number)
    end

    it 'should create a cf number from a 64 bit sized int' do
      expect(CF::Number.from_i(2**60)).to be_a(CF::Number)
    end
  end

  describe('to_i') do
    it 'should return a ruby integer representing the cfnumber' do
      expect(CF::Number.from_i(2**60).to_i).to eq(2**60)
    end

    it 'should raise error for precision loss' do
      val = CF::Number.from_f(Math::PI)
      expect { val.to_i }.to raise_error("CF.CFNumberGetValue failed to convert #{val.inspect} to kCFNumberSInt64Type")
    end
  end

  describe('to_f') do
    it 'should return a ruby float representing the cfnumber' do
      expect(CF::Number.from_f(3.1415).to_f).to be_within(0.0000001).of(3.14150)
    end
  end
end