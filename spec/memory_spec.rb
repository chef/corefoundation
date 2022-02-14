require 'spec_helper'

describe CF::Memory do
  describe 'release' do
    subject { CF::String.from_string("sample") }

    it 'successfully releases an object from memory' do
      expect { subject.release }.to_not raise_error
    end
  end
end