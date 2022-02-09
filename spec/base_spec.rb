require 'spec_helper'

describe CF::Base do
  context '==' do
    subject { CF::NULL }

    it { is_expected.to be_a(CF::Base) }

    describe 'when passed a non CFType value' do
      it 'should return false' do
        expect(subject == 1).to eq(false)
      end
    end

  end

  context 'equals?' do
    subject { CF::String.from_string("sample") }

    it { is_expected.to be_a(CF::Base) }

    describe 'when passed CFType value' do
      it 'should return true when the same object is passed' do
        expect(subject.equals? subject).to eq(true)
      end
  
      it 'should return false when two different objects are passed' do
        expect(subject.equals? CF::String.from_string("sample")).to eq(false)
      end
    end
    
    describe 'when passed a non CFType value' do
      it 'should return false' do
        expect(subject.equals? "sample").to eq(false)
      end
    end
  end

  context 'finalizer' do
    it 'successfully runs for a valid CFBase object' do
      expect(CF::Base).to receive(:finalize).and_call_original
      sample = CF::String.from_string("sample")
      sample = nil
      GC.start
    end
  end

  describe 'klass_from_cf_type' do
    subject { FFI::MemoryPointer.new(:pointer) }

    it 'raises error when provided with a type that not registered' do
      expect { CF::Base.typecast(subject) }.to raise_error(TypeError)
    end
  end

end