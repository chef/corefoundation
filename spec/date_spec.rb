require 'spec_helper'

describe CF::Date do
  describe('from_time') do
    it 'should create a cf date from a time' do
      expect(CF::Date.from_time(Time.now)).to be_a(CF::Date)
    end
  end

  describe('to_time') do
    it 'should return a time' do
      t = CF::Date.from_time(Time.now).to_time
      expect(t).to be_a(Time)
      expect(t).to be_within(0.01).of(Time.now)
    end
  end

  describe 'to_ruby' do
    it 'should behave like to_time' do
      t = CF::Date.from_time(Time.now).to_ruby
      expect(t).to be_a(Time)
    end
  end
end

