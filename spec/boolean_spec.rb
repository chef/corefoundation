require 'spec_helper'

describe CF do


  describe CF::Boolean do
    describe 'value' do
      it 'should return true for CF::Boolean::TRUE' do
        expect(CF::Boolean::TRUE.value).to eq(true)
      end
      it 'should return false for CF::Boolean::FALSE' do
        expect(CF::Boolean::FALSE.value).to eq(false)
      end
    end

    describe 'to_ruby' do
      it 'should behave like value' do
        expect(CF::Boolean::FALSE.to_ruby).to eq(false)
      end
    end

  end

end