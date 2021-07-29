require "spec_helper"

describe CF::Array do
  describe "mutable" do
    subject { CF::Array.mutable }

    it { is_expected.to be_a(CF::Array) }
    it { is_expected.to be_mutable }

    describe "[]=" do
      it "should raise when trying to store a non cf value" do
        expect { subject[0] = 123 }.to raise_error(TypeError)
      end
    end

    describe "<<" do
      it "should raise when trying to store a non cf value" do
        expect { subject << 123 }.to raise_error(TypeError)
      end
    end
  end

  describe "immutable" do
    it "should raise if all of the array elements are not cf values" do
      expect { CF::Array.immutable([CF::Boolean::TRUE, 1]) }.to raise_error(TypeError)
    end

    it "should return an immutable cfarray" do
      expect(CF::Array.immutable([CF::Boolean::TRUE])).to be_a(CF::Array)
    end

    context "with an immutable array" do
      subject { CF::Array.immutable([CF::Boolean::TRUE, CF::String.from_string("123")]) }

      describe "[]=" do
        it "should raise TypeError" do
          expect { subject[0] = CF::Boolean::TRUE }.to raise_error(TypeError)
        end
      end

      describe "<<" do
        it "should raise TypeError" do
          expect { subject << CF::Boolean::TRUE }.to raise_error(TypeError)
        end
      end
    end
  end

  context "with an array" do
    subject { CF::Array.immutable([CF::Boolean::TRUE, CF::String.from_string("123")]) }

    describe "[]" do
      it "should return the typecast value at the index" do
        expect(subject[1]).to be_a(CF::String)
        expect(subject[1]).to eq(CF::String.from_string("123"))
      end
    end

    describe "length" do
      it "should return the count of items in the dictionary" do
        expect(subject.length).to eq(2)
      end
    end

    describe "to_ruby" do
      it "should return the result of calling to ruby on its contents" do
        expect(subject.to_ruby).to eq([true, "123"])
      end
    end

    describe "each" do
      it "should iterate over each value" do
        values = []
        subject.each do |v|
          values << v
        end
        expect(values[0]).to eq(CF::Boolean::TRUE)
        expect(values[1]).to eq(CF::String.from_string("123"))
      end
    end

    it "should be enumerable" do
      values = {}
      subject.each_with_index do |value, index|
        values[index] = value
      end
      expect(values).to eq({ 0 => CF::Boolean::TRUE, 1 => CF::String.from_string("123") })
    end
  end
end
