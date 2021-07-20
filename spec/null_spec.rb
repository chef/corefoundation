# frozen_string_literal: true

require 'spec_helper'

describe CF::Null do
  it 'should be null' do
    CF::NULL.should be_null
  end
end
