require 'spec_helper'

describe CF::Register do
  describe 'klass_from_cf_type' do
    subject { FFI::MemoryPointer.new(:pointer) }

    it 'raises error when provided with a type that not registered' do
      expect { CF::Base.typecast(subject) }.to raise_error(TypeError)
    end
  end

end