require 'spec_helper'

describe CF::Array do
  describe 'mutable' do
    subject { CF::Array.mutable }

    it { is_expected.to be_a(CF::Array) }
    it { is_expected.to be_mutable }

    describe '[]=' do
      it 'should raise when trying to store a non cf value' do
        expect {subject[0] = 123}.to raise_error(TypeError)
      end

      it 'should update the value at index when trying to store a cf value' do
        expect {subject[0] = CF::Number.from_i(123)}.to_not raise_error
        expect(subject[0] == CF::Number.from_i(123)).to eq(true)
      end
    end

    describe '<<' do
      it 'should raise when trying to store a non cf value' do
        expect {subject << 123}.to raise_error(TypeError)
      end
      it 'should successfully store a cf value' do
        expect {subject << CF::Number.from_i(123)}.to_not raise_error
        expect(subject[0] == CF::Number.from_i(123)).to eq(true)
      end
    end

  end

  describe 'immutable' do
    it 'should raise if all of the array elements are not cf values' do
      expect {CF::Array.immutable([CF::Boolean::TRUE, 1])}.to raise_error(TypeError)
    end

    it 'should return an immutable cfarray' do
      expect(CF::Array.immutable([CF::Boolean::TRUE])).to be_a(CF::Array)
    end
    
    context 'with an immutable array' do
      subject { CF::Array.immutable([CF::Boolean::TRUE, CF::String.from_string('123')])}

      describe '[]=' do
        it 'should raise TypeError' do
          expect {subject[0] = CF::Boolean::TRUE}.to raise_error(TypeError)
        end
      end

      describe '<<' do
        it 'should raise TypeError' do
          expect {subject << CF::Boolean::TRUE}.to raise_error(TypeError)
        end
      end
    end
  end

  context "with an array" do
    subject { CF::Array.immutable([CF::Boolean::TRUE, CF::String.from_string('123')])}

    describe '[]' do
      it 'should return the typecast value at the index' do
        expect(subject[1]).to be_a(CF::String)
        expect(subject[1]).to eq(CF::String.from_string('123'))
      end
    end


    describe 'length' do
      it 'should return the count of items in the dictionary' do
        expect(subject.length).to eq(2)
      end
    end

    describe 'to_ruby' do
      it 'should return the result of calling to ruby on its contents' do
        expect(subject.to_ruby).to eq([true, '123'])
      end
    end

    describe 'each' do 
      it 'should iterate over each value' do
        values = []
        subject.each do |v|
          values << v
        end
        expect(values[0]).to eq(CF::Boolean::TRUE)
        expect(values[1]).to eq(CF::String.from_string('123'))
      end
    end

    it 'should be enumerable' do
      values = {}
      subject.each_with_index do |value, index|
        values[index] = value
      end
      expect(values).to eq({ 0 => CF::Boolean::TRUE, 1 => CF::String.from_string('123') })
    end
  end

  # Test to simulate the crash that occurs in Chef's macos_userdefaults resource
  # when processing array values on Intel macOS
  describe 'crash simulation for array processing on Intel macOS' do
    context 'with an array of file paths similar to Chef macos_userdefaults' do
      let(:file_paths) do
        [
          "/Library/Managed Installs/fake.log",
          "/Library/Managed Installs/also_fake.log"
        ]
      end

      it 'should successfully create an immutable array from string paths' do
        cf_strings = file_paths.map { |path| CF::String.from_string(path) }
        expect { CF::Array.immutable(cf_strings) }.not_to raise_error
      end

      it 'should successfully iterate over an array of file paths without segfault' do
        cf_strings = file_paths.map { |path| CF::String.from_string(path) }
        array = CF::Array.immutable(cf_strings)
        
        collected_values = []
        expect {
          array.each do |value|
            collected_values << value
          end
        }.not_to raise_error
        
        expect(collected_values.length).to eq(2)
        expect(collected_values[0]).to be_a(CF::String)
        expect(collected_values[1]).to be_a(CF::String)
      end

      it 'should successfully convert array to ruby without segfault' do
        cf_strings = file_paths.map { |path| CF::String.from_string(path) }
        array = CF::Array.immutable(cf_strings)
        
        expect { array.to_ruby }.not_to raise_error
        expect(array.to_ruby).to eq(file_paths)
      end

      it 'should handle CFArrayApplyFunction callback correctly' do
        cf_strings = file_paths.map { |path| CF::String.from_string(path) }
        array = CF::Array.immutable(cf_strings)
        
        # This directly tests the each method which calls CFArrayApplyFunction
        # where the segfault occurs at 0x0000000000000000
        values_from_callback = []
        expect {
          range = CF::Range.new
          range[:location] = 0
          range[:length] = array.length
          callback = lambda do |value, _|
            # value should be a valid pointer, not null
            expect(value).not_to be_nil
            expect(value.null?).to be false
            values_from_callback << CF::Base.typecast(value)
          end
          CF.CFArrayApplyFunction(array, range, callback, nil)
        }.not_to raise_error
        
        expect(values_from_callback.length).to eq(2)
      end
    end

    context 'with a mutable array of file paths' do
      let(:file_paths) do
        [
          "/Library/Managed Installs/fake.log",
          "/Library/Managed Installs/also_fake.log"
        ]
      end

      it 'should successfully append and iterate over file paths in mutable array' do
        array = CF::Array.mutable
        
        file_paths.each do |path|
          cf_string = CF::String.from_string(path)
          expect { array << cf_string }.not_to raise_error
        end
        
        expect(array.length).to eq(2)
        
        collected_values = []
        expect {
          array.each do |value|
            collected_values << value.to_ruby
          end
        }.not_to raise_error
        
        expect(collected_values).to eq(file_paths)
      end
    end

    context 'with refinements (simulating Chef usage pattern)' do
      using CF::Refinements

      let(:file_paths) do
        [
          "/Library/Managed Installs/fake.log",
          "/Library/Managed Installs/also_fake.log"
        ]
      end

      it 'should convert Ruby array to CF array using refinements without segfault' do
        cf_array = nil
        expect {
          cf_array = file_paths.to_cf
        }.not_to raise_error
        
        expect(cf_array).to be_a(CF::Array)
        expect(cf_array.length).to eq(2)
      end

      it 'should iterate over CF array created from refinements without segfault' do
        cf_array = file_paths.to_cf
        
        collected_values = []
        expect {
          cf_array.each do |value|
            collected_values << value
          end
        }.not_to raise_error
        
        expect(collected_values.length).to eq(2)
        expect(collected_values.map(&:to_ruby)).to eq(file_paths)
      end

      it 'should successfully use array in preferences-like scenario' do
        # This simulates the usage pattern in Chef's macos_userdefaults
        cf_array = file_paths.to_cf
        
        # Test that we can retrieve individual elements
        expect { cf_array[0] }.not_to raise_error
        expect { cf_array[1] }.not_to raise_error
        
        expect(cf_array[0].to_ruby).to eq(file_paths[0])
        expect(cf_array[1].to_ruby).to eq(file_paths[1])
        
        # Test that we can convert back to Ruby
        expect { cf_array.to_ruby }.not_to raise_error
        expect(cf_array.to_ruby).to eq(file_paths)
      end
    end
  end
end